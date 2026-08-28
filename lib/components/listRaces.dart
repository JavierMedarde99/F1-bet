import 'package:f1/betPage.dart';
import 'package:f1/components/cardPage.dart';
import 'package:f1/components/error_retry.dart';
import 'package:f1/models/circuits.dart';
import 'package:f1/resultPage.dart';
import 'package:f1/utils/f1Api.dart';
import 'package:f1/utils/theme.dart';
import 'package:flutter/material.dart';

class ListRaces extends StatefulWidget {
  final int userId;
  ListRaces({required this.userId});

  @override
  _ListRacesState createState() => _ListRacesState();
}

class _ListRacesState extends State<ListRaces> {
  late Future<List<Circuit>> circuits;

  // Formatea la fecha de la carrera como dd/MM/yyyy
  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  @override
  void initState() {
    super.initState();
    circuits = getCircuits();
  }

  // Recarga la lista de circuitos; el FutureBuilder muestra el spinner
  // hasta que el nuevo Future termina.
  Future<void> _reloadCircuits() {
    final future = getCircuits();
    setState(() {
      circuits = future;
    });
    return future;
  }

  // Reintenta la carga de circuitos
  Future<void> _retryLoad() async {
    final future = getCircuits();
    setState(() {
      circuits = future;
    });
  }

  // Depending on the race status, a button will be created for the following two actions: betting or viewing results.
  ElevatedButton actionCircuit(CircuitsState state, String meetingId) {
    switch (state) {
      case CircuitsState.result:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: GridColors.rossoCorsa,
            foregroundColor: GridColors.onSecondaryContainer,
            side: const BorderSide(color: GridColors.secondary),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => Resultpage(meetingId: meetingId),
              ),
            );
          },
          child: const Text("RESULTADOS"),
        );
      case CircuitsState.bet:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: const BorderSide(color: GridColors.limeDim),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) =>
                    Betpage(userId: widget.userId, meetingId: meetingId),
              ),
            );
          },
          child: const Text("APOSTAR"),
        );
      case CircuitsState.future:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: GridColors.containerHighest,
            disabledForegroundColor: GridColors.outline,
            side: const BorderSide(color: GridColors.outlineVariant),
          ),
          onPressed: null,
          child: const Text("FUTURA"),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: circuits,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Circuit> data = snapshot.data!;
          return Container(
            color: GridColors.surface,
            child: RefreshIndicator(
              onRefresh: _reloadCircuits,
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final circuit = data[index];

                  return Cardpage(
                    image: Image.network(
                      circuit.imagen,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.grey,
                        );
                      },
                    ),
                    text: circuit.name,
                    date: _formatDate(circuit.dateEnd),
                    container: Container(
                      child: actionCircuit(
                        circuit.state,
                        circuit.meetingId.toString(),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Errorretry(
            message: "Error loading circuits, please try again.",
            onRetry: _retryLoad,
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

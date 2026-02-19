import 'package:f1/betPage.dart';
import 'package:f1/components/cardPage.dart';
import 'package:f1/models/cicuits.dart';
import 'package:f1/resultPage.dart';
import 'package:f1/utils/f1Api.dart';
import 'package:flutter/material.dart';

class ListRaces extends StatefulWidget {
  final int userId;
  ListRaces({required this.userId});

  @override
  _ListRacesState createState() => _ListRacesState();
}

class _ListRacesState extends State<ListRaces> {
  Future<List<Circuit>> circuits = getCircuits();

  ElevatedButton actionCircuit(CircuitsState state, String meetingId) {
    switch (state) {
      case CircuitsState.result:
        return ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => Resultpage(meetingId: meetingId),
              ),
            );
          },
          child: Text("Resultados"),
        );
      case CircuitsState.bet:
        return ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) =>
                    Betpage(userId: widget.userId, meetingId: meetingId),
              ),
            );
          },
          child: Text("Apostar"),
        );
      case CircuitsState.future:
        return ElevatedButton(onPressed: null, child: Text("Futura Apostar"));
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8B0000), // rojo oscuro
                  Color(0xFFE10600), // rojo F1 intenso
                  Color(0xFF1C1C1C), // negro elegante
                ],
              ),
            ),
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final circuit = data[index];

                return Cardpage(
                  image: Image.network(
                    circuit.imagen,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  text: circuit.name,
                  container: Container(
                    child: actionCircuit(
                      circuit.state,
                      circuit.meetingId.toString(),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text("Error loading circuits, please try again later.");
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

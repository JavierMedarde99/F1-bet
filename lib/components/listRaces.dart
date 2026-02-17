import 'package:f1/betPage.dart';
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
      child: FutureBuilder(
        future: circuits,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Circuit> data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final circuit = data[index];

                return Padding(
                  
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          /// 📷 MITAD IZQUIERDA - IMAGEN
                          Expanded(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                              ),
                              child: Image.network(
                                circuit.imagen,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          /// 🏁 MITAD DERECHA - INFO
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Nombre circuito
                                  Text(
                                    circuit.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  /// Botón dinámico
                                  actionCircuit(
                                    circuit.state,
                                    circuit.meetingId.toString(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("Error loading circuits, please try again later.");
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

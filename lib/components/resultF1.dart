import 'package:flutter/material.dart';

class Resultf1  extends StatelessWidget {

  final String alonsoPosition;
  final String sainzPosition;

  Resultf1({required this.alonsoPosition, required this.sainzPosition});

  @override
  Widget build(BuildContext context) {
    return Column(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    const Text(
      "Resultados de la carrera",
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white
      ),
    ),
    const SizedBox(height: 20),

    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Recuadro Alonso
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 140,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "Alonso",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  alonsoPosition,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 20),

        // Recuadro Sainz
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 140,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "Sainz",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  sainzPosition,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ],
);
  }
}
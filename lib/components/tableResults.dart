import 'package:f1/models/resultTable.dart';
import 'package:f1/models/results.dart';
import 'package:flutter/material.dart';

class Tableresults extends StatefulWidget {
  final Results results;

  const Tableresults({Key? key, required this.results}) : super(key: key);

  @override
  _TableresultsState createState() => _TableresultsState();
}

class _TableresultsState extends State<Tableresults> {

  int getDifferense(int alonsoPosition, int sainzPosition, int alonsopositionBet, int sainzPositionBet) {
    int differenseAlonso = (alonsopositionBet - alonsoPosition).abs();
    int differenseSainz = (sainzPositionBet - sainzPosition).abs();
    return differenseAlonso + differenseSainz;
  }

  List<ResultTable> get resultTable {
    final list = widget.results.resultsUser.map((result) => ResultTable(
      name: result.name,
      positionAlonso: result.alonsoPosition,
      positionSainz: result.sainzPosition,
      totalDifferense: getDifferense(
        widget.results.resultsRaces.alonsoPositionBet,
        widget.results.resultsRaces.sainzPositionBet,
        result.alonsoPosition,
        result.sainzPosition,
      ),
    )).toList();

    list.sort((a, b) => b.totalDifferense.compareTo(a.totalDifferense));

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Tabla de resultados",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
          const SizedBox(height: 20),
          DataTable(
            headingRowColor: WidgetStateProperty.all(Colors.black),
            headingTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            columns: const <DataColumn>[
              DataColumn(label: Text('Usuario')),
              DataColumn(label: Text('Alonso')),
              DataColumn(label: Text('Sainz')),
              DataColumn(label: Text('Diferencia')),
            ],
            rows: List.generate(resultTable.length, (index) {
              final result = resultTable[index];

              return DataRow(
                color: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (index == 0) {
                      return Colors.red; // Primera fila roja
                    }
                    return Colors.green; // Resto verdes
                  },
                ),
                cells: [
                  DataCell(Text(result.name)),
                  DataCell(Text(result.positionAlonso.toString())),
                  DataCell(Text(result.positionSainz.toString())),
                  DataCell(Text(result.totalDifferense.toString())),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

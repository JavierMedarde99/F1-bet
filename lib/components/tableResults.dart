import 'package:f1/models/resultTable.dart';
import 'package:f1/models/results.dart';
import 'package:flutter/material.dart';

class Tableresults extends StatefulWidget {

  final Results results;

  Tableresults({required this.results});

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
      child: Column(
        children: [
          Text("Tabla de resultados"),
          DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Usuario',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Apuesta Alonso',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Apuesta Sainz',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Diferencia Total',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
            rows: resultTable.map((result) => DataRow(cells: [
                      DataCell(Text(result.name)),
                      DataCell(Text(result.positionAlonso.toString())),
                      DataCell(Text(result.positionSainz.toString())),
                      DataCell(Text(result.totalDifferense.toString())),
                    ]))
                .toList(),
          ),
        ],
      ),
    );
  }
}
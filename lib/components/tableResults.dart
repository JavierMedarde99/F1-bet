import 'package:f1/models/results.dart';
import 'package:f1/models/resultTable.dart';
import 'package:f1/utils/theme.dart';
import 'package:flutter/material.dart';

class TableResults extends StatefulWidget {
  final Results results;

  const TableResults({Key? key, required this.results}) : super(key: key);

  @override
  _TableResultsState createState() => _TableResultsState();
}

class _TableResultsState extends State<TableResults> {

  int getDifferense(int alonsoPosition, int sainzPosition, int alonsoPositionBet, int sainzPositionBet) {
    int differenseAlonso = (alonsoPositionBet - alonsoPosition).abs();
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

    // El ganador es quien tiene MENOR diferencia con el resultado real
    list.sort((a, b) => a.totalDifferense.compareTo(b.totalDifferense));

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(GridSpacing.gutter),
      child: Column(
        children: [
          Text(
            "TABLA DE RESULTADOS",
            style: GridTypography.labelCaps(color: GridColors.lime),
          ),
          const SizedBox(height: GridSpacing.gutter),
          DataTable(
            columns: const <DataColumn>[
              DataColumn(label: Text('USUARIO')),
              DataColumn(label: Text('ALONSO')),
              DataColumn(label: Text('SAINZ')),
              DataColumn(label: Text('RESTO')),
            ],
            rows: List.generate(resultTable.length, (index) {
              final result = resultTable[index];

              return DataRow(
                color: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (index == 0) {
                      // Ganador: fila destacada con acento lima
                      return GridColors.primaryContainer.withValues(alpha: 0.12);
                    }
                    return null;
                  },
                ),
                cells: [
                  DataCell(
                    Text(
                      result.name.toUpperCase(),
                      style: GridTypography.dataMono(color: GridColors.onSurface),
                    ),
                  ),
                  DataCell(Text('${result.positionAlonso}')),
                  DataCell(Text('${result.positionSainz}')),
                  DataCell(
                    Text(
                      '${result.totalDifferense}',
                      style: GridTypography.dataMono(color: GridColors.rossoCorsa),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

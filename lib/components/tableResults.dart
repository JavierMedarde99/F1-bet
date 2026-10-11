import 'package:f1/models/results.dart';
import 'package:f1/models/resultTable.dart';
import 'package:f1/utils/theme.dart';
import 'package:flutter/material.dart';

// Error absoluto total de una apuesta: |real - apuesta| para Alonso y Sainz.
int betError({
  required int realAlonso,
  required int realSainz,
  required int betAlonso,
  required int betSainz,
}) {
  return (realAlonso - betAlonso).abs() + (realSainz - betSainz).abs();
}

// Construye la tabla ordenada de mayor a menor error (el "ganador" primero).
List<ResultTable> buildResultTable(Results results) {
  final list = results.resultsUser
      .map(
        (result) => ResultTable(
          name: result.name,
          positionAlonso: result.alonsoPosition,
          positionSainz: result.sainzPosition,
          totalDifference: betError(
            realAlonso: results.resultsRaces.alonsoPositionBet,
            realSainz: results.resultsRaces.sainzPositionBet,
            betAlonso: result.alonsoPosition,
            betSainz: result.sainzPosition,
          ),
        ),
      )
      .toList();

  // La mayor diferencia se muestra primero (orden descendente)
  list.sort((a, b) => b.totalDifference.compareTo(a.totalDifference));

  return list;
}

class TableResults extends StatefulWidget {
  final Results results;

  const TableResults({Key? key, required this.results}) : super(key: key);

  @override
  _TableResultsState createState() => _TableResultsState();
}

class _TableResultsState extends State<TableResults> {
  List<ResultTable> get resultTable => buildResultTable(widget.results);

  @override
  Widget build(BuildContext context) {
    final List<ResultTable> results = resultTable;

    return Container(
      padding: const EdgeInsets.all(GridSpacing.gutter),
      child: Column(
        children: [
          Text(
            "TABLA DE RESULTADOS",
            style: GridTypography.labelCaps(color: GridColors.lime),
          ),
          const SizedBox(height: GridSpacing.gutter),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              horizontalMargin: 0,
              columnSpacing: GridSpacing.unit * 6,
              columns: const <DataColumn>[
                DataColumn(label: Text('USUARIO')),
                DataColumn(label: Text('ALONSO')),
                DataColumn(label: Text('SAINZ')),
                DataColumn(label: Text('RESTO')),
              ],
              rows: List.generate(results.length, (index) {
                final result = results[index];

                // Mayor(es) diferencia: toda fila con la diferencia máxima (incluye empates)
                final bool isWinner =
                    result.totalDifference == results.first.totalDifference;

                return DataRow(
                  color: WidgetStateProperty.resolveWith<Color?>((
                    Set<WidgetState> states,
                  ) {
                    if (isWinner) {
                      // Mayor diferencia: fila destacada en rojo corsa
                      return GridColors.rossoCorsa.withValues(alpha: 0.12);
                    }
                    return null;
                  }),
                  cells: [
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 140),
                        child: Text(
                          result.name.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: GridTypography.dataMono(
                            color: GridColors.onSurface,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${result.positionAlonso}',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    DataCell(
                      Text(
                        '${result.positionSainz}',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    DataCell(
                      Text(
                        '${result.totalDifference}',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: GridTypography.dataMono(
                          color: GridColors.rossoCorsa,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

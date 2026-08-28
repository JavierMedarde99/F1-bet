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
  int getDifferense(
    int alonsoPosition,
    int sainzPosition,
    int alonsoPositionBet,
    int sainzPositionBet,
  ) {
    int differenseAlonso = (alonsoPositionBet - alonsoPosition).abs();
    int differenseSainz = (sainzPositionBet - sainzPosition).abs();
    return differenseAlonso + differenseSainz;
  }

  List<ResultTable> get resultTable {
    final list = widget.results.resultsUser
        .map(
          (result) => ResultTable(
            name: result.name,
            positionAlonso: result.alonsoPosition,
            positionSainz: result.sainzPosition,
            totalDifferense: getDifferense(
              widget.results.resultsRaces.alonsoPositionBet,
              widget.results.resultsRaces.sainzPositionBet,
              result.alonsoPosition,
              result.sainzPosition,
            ),
          ),
        )
        .toList();

    // La mayor diferencia se muestra primero (orden descendente)
    list.sort((a, b) => b.totalDifferense.compareTo(a.totalDifferense));

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
              rows: List.generate(resultTable.length, (index) {
                final result = resultTable[index];

                // Mayor(es) diferencia: toda fila con la diferencia máxima (incluye empates)
                final bool isWinner =
                    result.totalDifferense == resultTable.first.totalDifferense;

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
                        '${result.totalDifferense}',
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

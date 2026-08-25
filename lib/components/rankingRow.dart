import 'package:f1/models/ranking.dart';
import 'package:f1/utils/theme.dart';
import 'package:flutter/material.dart';

/// Fila de la clasificación de pérdidas.
///
/// - Posición coloreada por rango (1º lima, último rojo corsa).
/// - Nombre en mayúsculas.
/// - Columna de pérdidas en rojo corsa.
/// - El mayor perdedor se destaca con fondo lima translúcido.
class RankingRow extends StatelessWidget {
  final RankingUser user;
  final int position;
  final int totalRows;

  const RankingRow({
    super.key,
    required this.user,
    required this.position,
    required this.totalRows,
  });

  Color _positionColor() {
    if (position == 1) return GridColors.lime;
    if (position == totalRows) return GridColors.rossoCorsa;
    return GridColors.onSurfaceVariant;
  }

  @override
  Widget build(BuildContext context) {
    final bool isTopLoser = position == 1 && user.totalLosses > 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GridSpacing.gutter,
        vertical: GridSpacing.unit * 3,
      ),
      decoration: BoxDecoration(
        color: isTopLoser
            ? GridColors.primaryContainer.withValues(alpha: 0.12)
            : GridColors.container,
        border: Border(
          left: BorderSide(
            color: isTopLoser ? GridColors.lime : GridColors.outlineVariant,
            width: 4,
          ),
          bottom: const BorderSide(color: GridColors.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          // Posición
          SizedBox(
            width: 40,
            child: Text(
              '$position',
              style: GridTypography.oddsLg(color: _positionColor()),
            ),
          ),
          // Usuario
          Expanded(
            child: Text(
              user.name.toUpperCase(),
              style: GridTypography.dataMono(color: GridColors.onSurface),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Carreras disputadas
          Padding(
            padding: const EdgeInsets.only(right: GridSpacing.gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('CARRERAS', style: GridTypography.labelCaps()),
                Text('${user.racesCount}', style: GridTypography.dataMono()),
              ],
            ),
          ),
          // Pérdidas acumuladas
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('PÉRDIDAS', style: GridTypography.labelCaps()),
              Text(
                '${user.totalLosses}',
                style: GridTypography.dataMono(color: GridColors.rossoCorsa),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

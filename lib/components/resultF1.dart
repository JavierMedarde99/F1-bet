import 'package:f1/utils/theme.dart';
import 'package:flutter/material.dart';

class ResultF1 extends StatelessWidget {
  final String alonsoPosition;
  final String sainzPosition;

  ResultF1({required this.alonsoPosition, required this.sainzPosition});

  // Módulo de telemetría: borde 1px con el acento del piloto
  Widget _telemetryModule(String name, String position, Color accent) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(GridSpacing.gutter),
      decoration: BoxDecoration(
        color: GridColors.containerLow,
        border: Border.all(color: accent),
      ),
      child: Column(
        children: [
          Text(
            name.toUpperCase(),
            style: GridTypography.labelCaps(color: accent),
          ),
          const SizedBox(height: GridSpacing.unit * 2),
          Text(position, style: GridTypography.oddsLg()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("RESULTADOS DE LA CARRERA", style: GridTypography.labelCaps()),
        const SizedBox(height: GridSpacing.gutter),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Alonso Box
            _telemetryModule("Alonso", alonsoPosition, GridColors.lime),

            const SizedBox(width: GridSpacing.gutter),

            // Sainz box
            _telemetryModule("Sainz", sainzPosition, GridColors.rossoCorsa),
          ],
        ),
      ],
    );
  }
}

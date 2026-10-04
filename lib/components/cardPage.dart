import 'package:f1/components/grid_decor.dart';
import 'package:f1/utils/theme.dart';
import 'package:flutter/material.dart';

/// Tarjeta de circuito: módulo de tablero con imagen HUD
/// (rejilla técnica superpuesta), barra de acento de estado
/// a la izquierda y acción de fase (ver DESIGN.md:
/// Race Status Tokens + Elevation).
class Cardpage extends StatelessWidget {
  final Image image;
  final String text;
  final Widget container;
  final String? date;

  /// Acento de estado: lima (apuesta abierta), rosso corsa
  /// (finalizada), asfalto (futura).
  final Color accent;

  const Cardpage({
    super.key,
    required this.image,
    required this.text,
    required this.container,
    this.date,
    this.accent = GridColors.outlineVariant,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: GridSpacing.gutter,
        vertical: GridSpacing.unit * 3,
      ),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: GridColors.container,
          border: Border(
            left: BorderSide(color: accent, width: 4),
            top: const BorderSide(color: GridColors.outlineVariant),
            bottom: const BorderSide(color: GridColors.outlineVariant),
            right: const BorderSide(color: GridColors.outlineVariant),
          ),
        ),
        child: Row(
          children: [
            /// IMAGEN con rejilla HUD superpuesta
            Expanded(
              flex: 3,
              child: ClipRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    image,
                    IgnorePointer(
                      child: CustomPaint(
                        painter: GridBackgroundPainter(
                          spacing: 16,
                          color: GridColors.containerLowest,
                          alpha: 0.22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// content with the container
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(GridSpacing.gutter),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title of the card
                    Text(
                      text.toUpperCase(),
                      style: GridTypography.labelCaps(
                        color: GridColors.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (date != null) ...[
                      const SizedBox(height: GridSpacing.unit),
                      Text(
                        date!,
                        style: GridTypography.dataMono(
                          color: GridColors.outline,
                        ),
                      ),
                    ],

                    const SizedBox(height: GridSpacing.unit * 3),

                    /// Container (button or input)
                    container,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:f1/utils/theme.dart';
import 'package:flutter/material.dart';

class Cardpage extends StatelessWidget {
  final Image image;
  final String text;
  final Widget container;
  final String? date;

  Cardpage({
    required this.image,
    required this.text,
    required this.container,
    this.date,
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
          border: Border.all(color: GridColors.outlineVariant),
        ),
        child: Row(
          children: [
            /// IMAGEN
            Expanded(flex: 1, child: ClipRect(child: image)),

            /// content with the container
            Expanded(
              flex: 1,
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

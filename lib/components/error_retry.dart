import 'package:f1/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Reusable full-screen error view with a retry button.
class Errorretry extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const Errorretry({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: GridColors.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 48,
              color: GridColors.rossoCorsa,
            ),
            const SizedBox(height: GridSpacing.margin),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: GridSpacing.margin),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: GridTypography.bodyMd(),
              ),
            ),
            const SizedBox(height: GridSpacing.gutter),
            ElevatedButton.icon(
              onPressed: () => onRetry(),
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('REINTENTAR'),
            ),
          ],
        ),
      ),
    );
  }
}

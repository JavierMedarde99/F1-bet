import 'package:f1/components/error_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUp(() {
    // Sin red en tests: GoogleFonts usa fallback, no descarga.
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('muestra el mensaje y REINTENTAR dispara onRetry', (
    tester,
  ) async {
    var retries = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Errorretry(
            message: 'Fallo de red',
            onRetry: () async {
              retries++;
            },
          ),
        ),
      ),
    );

    expect(find.text('Fallo de red'), findsOneWidget);

    await tester.tap(find.text('REINTENTAR'));
    await tester.pump();
    expect(retries, 1);
  });
}

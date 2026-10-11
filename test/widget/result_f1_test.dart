import 'package:f1/components/resultF1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUp(() {
    // Sin red en tests: GoogleFonts usa fallback, no descarga.
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('muestra la posición de ambos pilotos', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResultF1(alonsoPosition: '3', sainzPosition: '7'),
        ),
      ),
    );

    expect(find.text('RESULTADOS DE LA CARRERA'), findsOneWidget);
    expect(find.text('ALONSO'), findsOneWidget);
    expect(find.text('SAINZ'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
  });
}

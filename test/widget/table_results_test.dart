import 'package:f1/components/tableResults.dart';
import 'package:f1/models/results.dart';
import 'package:f1/models/resultsRaces.dart';
import 'package:f1/models/resultsUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUp(() {
    // Sin red en tests: GoogleFonts usa fallback, no descarga.
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Results sample() => Results(
    resultsRaces: ResultsRaces(alonsoPositionBet: 5, sainzPositionBet: 5),
    resultsUser: [
      ResultsUser(name: 'cero', alonsoPosition: 5, sainzPosition: 5),
      ResultsUser(name: 'ocho', alonsoPosition: 9, sainzPosition: 9),
    ],
  );

  Widget wrap() => MaterialApp(
    home: Scaffold(body: TableResults(results: sample())),
  );

  testWidgets('muestra cabecera, columnas y filas', (tester) async {
    await tester.pumpWidget(wrap());

    expect(find.text('TABLA DE RESULTADOS'), findsOneWidget);
    expect(find.text('USUARIO'), findsOneWidget);
    expect(find.text('ALONSO'), findsOneWidget);
    expect(find.text('SAINZ'), findsOneWidget);
    expect(find.text('RESTO'), findsOneWidget);
    expect(find.text('CERO'), findsOneWidget);
    expect(find.text('OCHO'), findsOneWidget);
  });

  testWidgets('ordena las filas por diferencia descendente', (tester) async {
    await tester.pumpWidget(wrap());

    final yOcho = tester.getTopLeft(find.text('OCHO')).dy;
    final yCero = tester.getTopLeft(find.text('CERO')).dy;
    expect(yOcho, lessThan(yCero));
  });

  testWidgets('resalta la fila con mayor diferencia', (tester) async {
    await tester.pumpWidget(wrap());

    final table = tester.widget<DataTable>(find.byType(DataTable));
    final winnerColor = table.rows.first.color?.resolve(<WidgetState>{});

    expect(winnerColor, isNotNull);
    expect(winnerColor!.a, closeTo(0.12, 0.01));
  });
}

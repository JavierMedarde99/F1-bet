import 'package:f1/components/FormBet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUp(() {
    // Sin red en tests: GoogleFonts usa fallback, no descarga.
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Widget wrap() {
    return MaterialApp(
      home: Scaffold(body: FormBet(userId: 1, meetingId: '1')),
    );
  }

  Future<void> pumpForm(WidgetTester tester) async {
    await tester.pumpWidget(wrap());
    // FormBet llama getBetForMeetingAndUser en initState; como Supabase no
    // está inicializado en el test, devuelve null y el formulario se monta.
    await tester.pumpAndSettle();
  }

  Finder fieldAt(int index) => find.byType(TextField).at(index);

  testWidgets('muestra los dos campos de posicion y el boton', (tester) async {
    await pumpForm(tester);

    expect(find.text('APUESTA A ALONSO'), findsOneWidget);
    expect(find.text('APUESTA A SAINZ'), findsOneWidget);
    expect(find.text('ENVIAR APUESTA'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('avisa si faltan campos', (tester) async {
    await pumpForm(tester);

    await tester.enterText(fieldAt(0), '7');
    await tester.tap(find.text('ENVIAR APUESTA'));
    await tester.pump();

    expect(find.text('Debes rellenar ambos campos'), findsOneWidget);
  });

  testWidgets('rechaza posicion fuera de rango (21)', (tester) async {
    await pumpForm(tester);

    await tester.enterText(fieldAt(0), '21');
    await tester.enterText(fieldAt(1), '4');
    await tester.tap(find.text('ENVIAR APUESTA'));
    await tester.pump();

    expect(
      find.text('Las posiciones deben estar entre 1 y 20'),
      findsOneWidget,
    );
  });

  testWidgets('rechaza posicion 0', (tester) async {
    await pumpForm(tester);

    await tester.enterText(fieldAt(0), '0');
    await tester.enterText(fieldAt(1), '4');
    await tester.tap(find.text('ENVIAR APUESTA'));
    await tester.pump();

    expect(
      find.text('Las posiciones deben estar entre 1 y 20'),
      findsOneWidget,
    );
  });

  testWidgets('acepta posicion en rango y envia la apuesta', (tester) async {
    await pumpForm(tester);

    await tester.enterText(fieldAt(0), '7');
    await tester.enterText(fieldAt(1), '12');
    await tester.tap(find.text('ENVIAR APUESTA'));
    await tester.pump();

    // al llegar a sendBet (que falla por no haber Supabase en el test),
    // no debe mostrarse el aviso de validación.
    expect(find.text('Las posiciones deben estar entre 1 y 20'), findsNothing);
  });
}

import 'package:f1/components/FormLogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUp(() {
    // Evita que GoogleFonts intente descargar fuentes en el test (sin red).
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Widget wrap() {
    return MaterialApp(home: Scaffold(body: Formlogin()));
  }

  testWidgets('boton ENTRAR con campos vacios muestra aviso', (tester) async {
    await tester.pumpWidget(wrap());

    await tester.tap(find.text('ENTRAR'));
    await tester.pump();

    expect(find.text('Por favor, rellena todos los campos'), findsOneWidget);
  });

  testWidgets('boton ENTRAR con solo usuario vacio tambien avisa', (
    tester,
  ) async {
    await tester.pumpWidget(wrap());

    await tester.enterText(find.byType(TextField).first, 'alonsorules');
    await tester.tap(find.text('ENTRAR'));
    await tester.pump();

    expect(find.text('Por favor, rellena todos los campos'), findsOneWidget);
  });

  testWidgets('formulario muestra los 4 elementos clave', (tester) async {
    await tester.pumpWidget(wrap());

    expect(find.text('INICIAR SESIÓN'), findsOneWidget);
    expect(find.text('USUARIO'), findsOneWidget);
    expect(find.text('CONTRASEÑA'), findsOneWidget);
    expect(find.text('ENTRAR'), findsOneWidget);
  });
}

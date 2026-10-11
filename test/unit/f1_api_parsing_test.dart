import 'package:f1/models/circuits.dart';
import 'package:f1/utils/f1Api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseDriverPosition', () {
    test('devuelve la posición cuando existe', () {
      expect(
        parseDriverPosition([
          {'position': 3},
        ]),
        3,
      );
    });

    test('-1 cuando no hay datos del piloto', () {
      expect(parseDriverPosition([]), -1);
    });

    test('-2 cuando el piloto no terminó (posición nula)', () {
      expect(
        parseDriverPosition([
          {'position': null},
        ]),
        -2,
      );
    });

    test('solo mira el primer registro', () {
      expect(
        parseDriverPosition([
          {'position': 4},
          {'position': 9},
        ]),
        4,
      );
    });
  });

  group('parseRaceSessionKey', () {
    test('devuelve la última sesión (la carrera)', () {
      expect(
        parseRaceSessionKey([
          {'session_key': 101},
          {'session_key': 202},
        ]),
        202,
      );
    });
  });

  group('classifyCircuitState', () {
    test('negativo = carrera ya disputada (resultados)', () {
      expect(classifyCircuitState(-1), CircuitsState.result);
      expect(classifyCircuitState(-30), CircuitsState.result);
    });

    test('de 0 a 6 días = apuestas abiertas', () {
      expect(classifyCircuitState(0), CircuitsState.bet);
      expect(classifyCircuitState(6), CircuitsState.bet);
    });

    test('7 días o más = futura', () {
      expect(classifyCircuitState(7), CircuitsState.future);
      expect(classifyCircuitState(120), CircuitsState.future);
    });
  });

  group('daysFromToday', () {
    test('hoy es 0', () {
      final now = DateTime.now().toUtc();
      expect(daysFromToday(DateTime.utc(now.year, now.month, now.day)), 0);
    });

    test('fechas futuras y pasadas en días completos', () {
      final now = DateTime.now().toUtc();
      final today = DateTime.utc(now.year, now.month, now.day);
      expect(daysFromToday(today.add(const Duration(days: 5))), 5);
      expect(daysFromToday(today.subtract(const Duration(days: 5))), -5);
    });
  });
}

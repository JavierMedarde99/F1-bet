import 'package:f1/components/tableResults.dart';
import 'package:f1/models/results.dart';
import 'package:f1/models/resultsRaces.dart';
import 'package:f1/models/resultsUser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('betError', () {
    test('suma el error absoluto de ambos pilotos', () {
      expect(
        betError(realAlonso: 3, realSainz: 5, betAlonso: 5, betSainz: 2),
        equals(5),
      );
    });

    test('es cero con una apuesta perfecta', () {
      expect(
        betError(realAlonso: 1, realSainz: 2, betAlonso: 1, betSainz: 2),
        equals(0),
      );
    });

    test('es simétrico: sobreestimar y subestimar dan el mismo error', () {
      final alto = betError(
        realAlonso: 4,
        realSainz: 4,
        betAlonso: 9,
        betSainz: 1,
      );
      final bajo = betError(
        realAlonso: 4,
        realSainz: 4,
        betAlonso: 1,
        betSainz: 9,
      );
      expect(alto, equals(8));
      expect(bajo, equals(alto));
    });
  });

  group('buildResultTable', () {
    Results build(List<ResultsUser> users) => Results(
      resultsRaces: ResultsRaces(alonsoPositionBet: 5, sainzPositionBet: 5),
      resultsUser: users,
    );

    test('ordena de mayor a menor diferencia', () {
      final table = buildResultTable(
        build([
          ResultsUser(name: 'cero', alonsoPosition: 5, sainzPosition: 5),
          ResultsUser(name: 'siete', alonsoPosition: 10, sainzPosition: 7),
          ResultsUser(name: 'dos', alonsoPosition: 3, sainzPosition: 6),
        ]),
      );

      expect(table.map((r) => r.name).toList(), ['siete', 'dos', 'cero']);
      expect(table.map((r) => r.totalDifference).toList(), [7, 3, 0]);
    });

    test('conserva los empates a la misma diferencia sin perder filas', () {
      final table = buildResultTable(
        build([
          ResultsUser(name: 'a', alonsoPosition: 1, sainzPosition: 5),
          ResultsUser(name: 'b', alonsoPosition: 9, sainzPosition: 5),
        ]),
      );

      expect(table.length, 2);
      expect(table.every((r) => r.totalDifference == 4), isTrue);
    });

    test('devuelve una lista vacía si no hay usuarios', () {
      expect(buildResultTable(build([])), isEmpty);
    });
  });
}

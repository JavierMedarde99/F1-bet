import 'package:f1/utils/f1Api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('filterCircuits', () {
    test('incluye carreras normales', () {
      expect(
        filterCircuits('Monaco Grand Prix', DateTime(2026, 5, 24)),
        isTrue,
      );
    });

    test('excluye carreras Pre-Season', () {
      expect(
        filterCircuits('Pre-Season Testing', DateTime(2026, 2, 20)),
        isFalse,
      );
    });

    test('excluye nombres que contienen Pre-Season en cualquier posicion', () {
      expect(filterCircuits('Pre-Season', DateTime(2026, 2, 20)), isFalse);
    });

    test('la fecha no afecta al filtro de nombre', () {
      expect(
        filterCircuits('Bahrain Grand Prix', DateTime(2026, 3, 1)),
        isTrue,
      );
      expect(
        filterCircuits('Bahrain Grand Prix', DateTime(2024, 1, 1)),
        isTrue,
      );
    });
  });
}

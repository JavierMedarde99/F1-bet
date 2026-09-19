import 'package:f1/utils/connectionDataBase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isConfigurationValid', () {
    test('acepta URL https + key presente', () {
      expect(
        isConfigurationValid(
          url: 'https://zzzexample.supabase.co',
          anonKey: 'eyJhbGciOi',
        ),
        isTrue,
      );
    });

    test('rechaza url null', () {
      expect(isConfigurationValid(url: null, anonKey: 'eyJhbGciOi'), isFalse);
    });

    test('rechaza url vacia', () {
      expect(isConfigurationValid(url: '  ', anonKey: 'eyJhbGciOi'), isFalse);
    });

    test('rechaza url sin esquema (no http/https)', () {
      expect(
        isConfigurationValid(url: 'no-es-una-url', anonKey: 'eyJhbGciOi'),
        isFalse,
      );
    });

    test('rechaza anonKey null', () {
      expect(
        isConfigurationValid(
          url: 'https://zzzexample.supabase.co',
          anonKey: null,
        ),
        isFalse,
      );
    });

    test('rechaza anonKey vacia', () {
      expect(
        isConfigurationValid(
          url: 'https://zzzexample.supabase.co',
          anonKey: '   ',
        ),
        isFalse,
      );
    });

    test('recorta espacios delante y detras', () {
      expect(
        isConfigurationValid(
          url: '  https://zzzexample.supabase.co  ',
          anonKey: '  eyJhbGciOi  ',
        ),
        isTrue,
      );
    });
  });
}

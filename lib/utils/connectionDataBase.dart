import 'package:bcrypt/bcrypt.dart';
import 'package:f1/models/resultsUser.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Error type for database operations. Kept intentionally simple: callers
// can catch DatabaseException to distinguish DB failures from other errors.
class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}

// Logs a failed database call with a clear, consistent prefix so failures
// are never silently swallowed. UI behavior is unchanged for now.
void _reportError(String operation, Object error) {
  print('[DatabaseError] $operation failed: $error');
}

// conection to the dataBase
Future<void> connectiondatabase() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  // Nullable
  String? url = dotenv.env['DATABASE_URL'];
  String? anonKey = dotenv.env['ANON_KEY'];

  // Revisar null o cadena vacía
  if (url == null || url.isEmpty || anonKey == null || anonKey.isEmpty) {
    url = const String.fromEnvironment('DATABASE_URL');
    anonKey = const String.fromEnvironment('ANON_KEY');
  }

  // Validación final
  if (url.isEmpty || anonKey.isEmpty) {
    throw Exception('DATABASE_URL or ANON_KEY no está definido!');
  }

  await Supabase.initialize(url: url, anonKey: anonKey);
}

// get all the bets on a race
Future<List<ResultsUser>> getBetsForMeeting(String meetingBet) async {
  try {
    List<ResultsUser> resultsUser = [];

    final response = await Supabase.instance.client
        .from('bets')
        .select()
        .eq('meeting_bet', meetingBet);

    for (var bet in response) {
      resultsUser.add(
        ResultsUser(
          name: await getName(bet['user_id']),
          alonsoPosition: bet['alonso_position'],
          sainzPosition: bet['sainz_position'],
        ),
      );
    }

    return resultsUser;
  } catch (error) {
    _reportError('getBetsForMeeting', error);
    return [];
  }
}

// get a user's name
Future<String> getName(int idUser) async {
  try {
    final response = await Supabase.instance.client
        .from('users_f1')
        .select('user_name')
        .eq('id', idUser)
        .maybeSingle();

    if (response != null && response['user_name'] != null) {
      return response['user_name'];
    } else {
      return 'Usuario desconocido';
    }
  } catch (error) {
    _reportError('getName', error);
    return 'Usuario desconocido';
  }
}

//to obtain a bet on a specific race and user
Future<Map<String, dynamic>?> getBetForMeetingAndUser(
  int userId,
  String meetingBet,
) async {
  try {
    final response = await Supabase.instance.client
        .from('bets')
        .select()
        .eq('user_id', userId)
        .eq('meeting_bet', meetingBet)
        .maybeSingle();

    return response;
  } catch (error) {
    _reportError('getBetForMeetingAndUser', error);
    return null;
  }
}

// insert or update bet
Future<bool> sendBet(
  int userId,
  String meetingBet,
  int betAlonso,
  int betSainz,
  bool isExists,
) async {
  try {
    if (!isExists) {
      await Supabase.instance.client.from('bets').insert({
        'user_id': userId,
        'meeting_bet': meetingBet,
        'alonso_position': betAlonso,
        'sainz_position': betSainz,
      });
    } else {
      await Supabase.instance.client
          .from('bets')
          .update({'alonso_position': betAlonso, 'sainz_position': betSainz})
          .eq('user_id', userId)
          .eq('meeting_bet', meetingBet);
    }

    return true;
  } catch (error) {
    _reportError('sendBet', error);
    return false;
  }
}

// check if the username and password exist in the database.
// Las contraseñas se almacenan hasheadas con bcrypt; si se encuentra una
// contraseña legacy en texto plano, se verifica y se actualiza a hash.
Future<int> validateLogin(String username, String password) async {
  try {
    // Filtramos directamente en la consulta
    final response = await Supabase.instance.client
        .from('users_f1')
        .select('id, password')
        .eq('user_name', username)
        .maybeSingle(); // devuelve null si no hay coincidencia

    if (response == null) return 0;

    final String storedPassword = response['password'] ?? '';

    if (_isBcryptHash(storedPassword)) {
      return BCrypt.checkpw(password, storedPassword) ? response['id'] : 0;
    }

    // Migración transparente: hash de contraseñas legacy en texto plano
    if (storedPassword == password) {
      await _upgradeStoredPasswordToHash(response['id'], password);
      return response['id'];
    }

    return 0;
  } catch (error) {
    _reportError('validateLogin', error);
    return 0;
  }
}

bool _isBcryptHash(String value) {
  return value.startsWith(r'$2a$') ||
      value.startsWith(r'$2b$') ||
      value.startsWith(r'$2y$');
}

Future<void> _upgradeStoredPasswordToHash(int userId, String plain) async {
  try {
    final String hash = BCrypt.hashpw(plain, BCrypt.gensalt());
    await Supabase.instance.client
        .from('users_f1')
        .update({'password': hash})
        .eq('id', userId);
  } catch (error) {
    _reportError('_upgradeStoredPasswordToHash', error);
  }
}

import 'package:f1/models/resultsUser.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  await Supabase.initialize(
    url: url,
    anonKey: anonKey,
  );
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
      resultsUser.add(ResultsUser(
        name: await getName(bet['user_id']),
        alonsoPosition: bet['alonso_position'],
        sainzPosition: bet['sainz_position'],
      ));
    }

    return resultsUser;
  } catch (error) {
    print('Error fetching bets: $error');
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
    print('Error fetching user name: $error');
    return 'Usuario desconocido';
  }
}

//to obtain a bet on a specific race and user
Future<Map<String, dynamic>?> getBetForMeetingAndUser(
    int userId, String meetingBet) async {
  try {
    final response = await Supabase.instance.client
        .from('bets')
        .select()
        .eq('user_id', userId)
        .eq('meeting_bet', meetingBet)
        .maybeSingle();

    return response;
  } catch (error) {
    print('Error fetching bet: $error');
    return null;
  }
}

// insert or update bet
Future<bool> sendBet(
  int userId,
  String meetingBet,
  int betAlonso,
  int betSainz,
  bool isExists
) async {
  try {
    if(!isExists){
          await Supabase.instance.client.from('bets').insert({
      'user_id': userId,
      'meeting_bet': meetingBet,
      'alonso_position': betAlonso,
      'sainz_position': betSainz,
    });
    }else{
      await Supabase.instance.client.from('bets').update({
        'alonso_position': betAlonso,
        'sainz_position': betSainz,
      }).eq('user_id', userId).eq('meeting_bet', meetingBet);
    }


    return true; 
  } catch (error) {
    print('Error sending bet: $error');
    return false;
  }
}

// WARNING (SECURITY): passwords are stored AND compared in plaintext in
// the users_f1 table. If the database is ever exposed, every user's
// credentials are compromised. This is a known critical vulnerability.
//
// Recommended remediation (not implemented yet - tracked in issue #1):
//   1. Preferred: migrate to Supabase Auth (supabase.auth.signInWithPassword),
//      which handles secure hashing, recovery and email verification.
//   2. Alternative: keep users_f1 but store a hash (bcrypt/argon2) instead
//      of the raw password, hashing on registration and verifying on login.
// Any fix requires a data migration of the existing rows.
Future<int> validateLogin(String username, String password) async {
  try {
    // Filtramos directamente en la consulta
    final response = await Supabase.instance.client
        .from('users_f1')
        .select('id, password')
        .eq('user_name', username)
        .maybeSingle(); // devuelve null si no hay coincidencia

    if (response != null) {
      // PLAINTEXT COMPARISON - insecure, see warning above
      if (response['password'] == password) {
        return response['id'];
      }
    }

    return 0;
  } catch (error) {
    print('Error al obtener usuario: $error');
    return 0;
  }
}

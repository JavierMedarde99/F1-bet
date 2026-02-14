import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> connectiondatabase() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['DATABASE_URL']!,
    anonKey: dotenv.env['ANON_KEY']!,
  );
}

Future<bool> existsBet(int userId, String meetingBet) async {
  try {
    final response = await Supabase.instance.client
        .from('bets')
        .select()
        .eq('user_id', userId)
        .eq('meeting_bet', meetingBet);

    return response.isNotEmpty; // Si hay resultados, la apuesta existe
  } catch (error) {
    print('Error checking bet existence: $error');
    return false; // En caso de error, asumimos que no existe
  }
}

Future<List<Map<String, dynamic>>> getBetsForMeeting(int userId, String meetingBet) async {
  try {
    final response = await Supabase.instance.client
        .from('bets')
        .select()
        .eq('user_id', userId)
        .eq('meeting_bet', meetingBet);

    return List<Map<String, dynamic>>.from(response);
  } catch (error) {
    print('Error fetching bets for meeting: $error');
    return [];
  }
}

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


    return true; // Si llega aquí, todo OK
  } catch (error) {
    print('Error sending bet: $error');
    return false;
  }
}

Future<int> validateLogin(String username, String password) async {
  try {
    final users = await Supabase.instance.client.from('users_f1').select();

    for (var user in users) {
      if (user['user_name'] == username && user['password'] == password) {
        return user['id'];
      }
    }

    return 0; // No encontró coincidencias
  } catch (error) {
    print('Error al obtener usuarios: $error');
    return 0;
  }
}

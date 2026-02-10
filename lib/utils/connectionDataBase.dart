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


Future<bool> validateLogin(String username, String password) async {
  try {
    final users = await Supabase.instance.client
        .from('users_f1')
        .select();

    for (var user in users) {
      if (user['user_name'] == username && user['password'] == password) {
        return true;
      }
    }

    return false; // No encontró coincidencias
  } catch (error) {
    print('Error al obtener usuarios: $error');
    return false;
  }
}


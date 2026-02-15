import 'package:f1/components/FormLogin.dart';
import 'package:f1/utils/connectionDataBase.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await connectiondatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'apuesta F1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: const Formlogin(
      ),
    );
  }
}

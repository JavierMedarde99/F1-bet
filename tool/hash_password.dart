import 'dart:io';

import 'package:bcrypt/bcrypt.dart';

// Genera un hash bcrypt para almacenar contraseñas en users_f1.
//
// Uso:
//   dart run tool/hash_password.dart <contraseña>
//   dart run tool/hash_password.dart            (la pide por teclado)
void main(List<String> args) {
  String? password = args.isNotEmpty ? args.first : null;

  if (password == null || password.isEmpty) {
    stdout.write('Introduce la contraseña: ');
    password = stdin.readLineSync();
  }

  if (password == null || password.isEmpty) {
    stderr.writeln('Error: la contraseña no puede estar vacía.');
    exit(1);
  }

  print(BCrypt.hashpw(password, BCrypt.gensalt()));
}

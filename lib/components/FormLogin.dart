import 'package:f1/f1Page.dart';
import 'package:f1/utils/connectionDataBase.dart';
import 'package:flutter/material.dart';

class Formlogin extends StatefulWidget {
  const Formlogin({super.key});

  @override
  State<Formlogin> createState() => _FormloginState();
}

class _FormloginState extends State<Formlogin> {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usuarioController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: usuarioController,
          decoration: const InputDecoration(
            labelText: 'Usuario',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Contraseña',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            final usuario = usuarioController.text.trim();
            final password = passwordController.text.trim();

            if (usuario.isEmpty || password.isEmpty) return;

            int userId = await validateLogin(usuario, password);
            if (userId != 0) {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => F1page(userId: userId),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Credenciales incorrectas')),
              );
            }
          },
          child: const Text('Iniciar Sesión'),
        ),
      ],
    );
  }
}

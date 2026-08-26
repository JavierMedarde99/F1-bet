import 'package:f1/f1Page.dart';
import 'package:f1/utils/connectionDataBase.dart';
import 'package:f1/utils/theme.dart';
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'INICIAR SESIÓN',
          textAlign: TextAlign.center,
          style: GridTypography.labelCaps(color: GridColors.lime),
        ),
        const SizedBox(height: GridSpacing.margin),
        Text('USUARIO', style: GridTypography.labelCaps()),
        const SizedBox(height: GridSpacing.unit),
        TextField(
          controller: usuarioController,
          style: GridTypography.dataMono(),
        ),
        const SizedBox(height: GridSpacing.gutter),
        Text('CONTRASEÑA', style: GridTypography.labelCaps()),
        const SizedBox(height: GridSpacing.unit),
        TextField(
          controller: passwordController,
          obscureText: true, // to input password
          style: GridTypography.dataMono(),
        ),
        const SizedBox(height: GridSpacing.margin),
        ElevatedButton(
          onPressed: () async {
            //get the value of inputs
            final usuario = usuarioController.text.trim();
            final password = passwordController.text.trim();

            if (usuario.isEmpty || password.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Por favor, rellena todos los campos'),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }

            final result = await validateLogin(usuario, password);

            // go to the main page
            if (result.userId != 0) {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => F1page(userId: result.userId),
                ),
              );

              //show a error message
            } else {
              String msg;
              Color bg;
              switch (result.error) {
                case LoginError.networkError:
                  msg = 'Error de conexion. Intentalo de nuevo.';
                  bg = Colors.orange;
                  break;
                case LoginError.wrongCredentials:
                default:
                  msg = 'Credenciales incorrectas';
                  bg = GridColors.rossoCorsa;
                  break;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: bg),
              );
            }
          },
          child: const Text('ENTRAR'),
        ),
      ],
    );
  }
}

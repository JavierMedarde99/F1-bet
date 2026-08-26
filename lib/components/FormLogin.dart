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
  bool _isSubmitting = false;

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
          onPressed: _isSubmitting
              ? null
              : () async {
                  setState(() => _isSubmitting = true);

                  final usuario = usuarioController.text.trim();
                  final password = passwordController.text.trim();

                  if (usuario.isEmpty || password.isEmpty) {
                    if (!mounted) return;
                    setState(() => _isSubmitting = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, rellena todos los campos'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }

                  int userId = await validateLogin(usuario, password);

                  if (!mounted) return;
                  setState(() => _isSubmitting = false);

                  if (userId != 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => F1page(userId: userId),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Credenciales incorrectas'),
                        backgroundColor: GridColors.rossoCorsa,
                      ),
                    );
                  }
                },
          child: _isSubmitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('ENTRAR'),
        ),
      ],
    );
  }
}

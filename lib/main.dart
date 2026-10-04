import 'package:f1/components/FormLogin.dart';
import 'package:f1/utils/connectionDataBase.dart';
import 'package:f1/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Future<void> main() async {
  // conection to SupaBase
  await connectiondatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F1 Apuesta',
      debugShowCheckedModeBanner: false,
      theme: getGridTheme(),
      home: const LoginPage(),
    );
  }
}

// The homepage is the login page to access the website
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(GridSpacing.margin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo con borde lima de 2px
              Container(
                padding: const EdgeInsets.all(GridSpacing.gutter),
                decoration: BoxDecoration(
                  border: Border.all(color: GridColors.lime, width: 2),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.flagCheckered,
                  size: 48,
                  color: GridColors.lime,
                ),
              ),
              const SizedBox(height: GridSpacing.margin),
              Text(
                'F1 APUESTA',
                style: GridTypography.headlineLgMobile(color: GridColors.lime),
              ),
              const SizedBox(height: GridSpacing.margin),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.all(GridSpacing.gutter),
                decoration: BoxDecoration(
                  color: GridColors.containerLow,
                  border: Border.all(color: GridColors.outlineVariant),
                ),
                child: const Formlogin(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

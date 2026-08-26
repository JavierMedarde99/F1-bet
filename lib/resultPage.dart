import 'package:f1/components/listResults.dart';
import 'package:f1/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Resultpage extends StatelessWidget {
  final String meetingId;

  Resultpage({required this.meetingId});

  @override
  Widget build(BuildContext context) {
    final int? meetingKey = int.tryParse(meetingId);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.trophy,
              size: 18,
              color: GridColors.lime,
            ),
            const SizedBox(width: 12),
            const Text('RESULTADOS'),
          ],
        ),
      ),
      body: Center(
        child: meetingKey == null
            ? Text(
                'ID DE CARRERA INVÁLIDO',
                style: GridTypography.headlineLgMobile(),
              )
            : ListResults(meetingKey: meetingKey),
      ),
    );
  }
}

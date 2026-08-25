import 'package:f1/components/FormBet.dart';
import 'package:f1/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Betpage extends StatelessWidget {
  final int userId;
  final String meetingId;

  Betpage({required this.userId, required this.meetingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.handHoldingDollar,
              size: 18,
              color: GridColors.lime,
            ),
            const SizedBox(width: 12),
            const Text('APUESTA'),
          ],
        ),
      ),
      body: Center(
        child: FormBet(userId: userId, meetingId: meetingId)
      ),
    );
  }
}

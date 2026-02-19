import 'package:f1/components/FromBet.dart';
import 'package:flutter/material.dart';

class Betpage extends StatelessWidget {

  final int userId;
  final String meetingId;

  Betpage({required this.userId, required this.meetingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Apuesta F1"),
      ),
      body: Center(
        child: FromBet(userId: userId, meetingId: meetingId)
      ),
    );
  }
}
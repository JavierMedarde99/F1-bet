import 'package:f1/components/FromBet.dart';
import 'package:flutter/material.dart';

class Betpage extends StatelessWidget {

  final int userId;
  final String sessionId;

  Betpage({required this.userId, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result Page"),
      ),
      body: Center(
        child: FromBet(userId: userId, sessionId: sessionId)
      ),
    );
  }
}
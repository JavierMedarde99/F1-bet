import 'package:f1/components/listResults.dart';
import 'package:flutter/material.dart';

class Resultpage extends StatelessWidget {

  final String meetingId;

  Resultpage({required this.meetingId});

  @override
  Widget build(BuildContext context) {
    final int? meetingKey = int.tryParse(meetingId);

    return Scaffold(
      appBar: AppBar(
        title: Text("Result Page"),
      ),
      body: Center(
        child: meetingKey == null
            ? const Text('ID de carrera inválido')
            : Listresults(meetingKey: meetingKey),
      ),
    );
  }
}
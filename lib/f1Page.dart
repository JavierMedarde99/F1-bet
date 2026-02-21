import 'package:f1/components/listRaces.dart';
import 'package:flutter/material.dart';

//main page
class F1page extends StatelessWidget {

  final int userId;
  F1page({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "F1 all races",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: ListRaces(userId: userId,),
      ),
    );
  }
}
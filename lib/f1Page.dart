import 'package:f1/components/listRaces.dart';
import 'package:flutter/material.dart';


class F1page extends StatelessWidget {

  final int userId;
  F1page({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("F1 Page"),
      ),
      body: Center(
        child: ListRaces(userId: userId,),
      ),
    );
  }
}
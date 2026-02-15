import 'package:f1/components/tableResults.dart';
import 'package:f1/models/results.dart';
import 'package:f1/models/resultsRaces.dart';
import 'package:f1/models/resultsUser.dart';
import 'package:f1/utils/connectionDataBase.dart';
import 'package:f1/utils/f1Api.dart';
import 'package:flutter/material.dart';

class Listresults extends StatefulWidget {

  final int meetingKey;
  Listresults({required this.meetingKey});

  @override
  _ListresultState createState() => _ListresultState();
}

class _ListresultState extends State<Listresults> {

  late Future<List<Results>> results;

@override
void initState() {
  super.initState();
  results = Future.wait([
    getResults(widget.meetingKey),
    getBetsForMeeting(widget.meetingKey.toString()),
  ]).then((results) {
    return [
      Results(
        resultsRaces: results[0] as ResultsRaces,
        resultsUser: results[1] as List<ResultsUser>,
      )
    ];
  });
}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Results>>(
      future: results,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Container(child: Text("Error: ${snapshot.error}"));
        }

        final races = snapshot.data!;

        if(races[0].resultsRaces.alonsoPositionBet == -1 || races[0].resultsRaces.sainzPositionBet == -1){
          return Container(
            child: Text("No hay resultados disponibles"),
          );
        }

        if(races[0].resultsRaces.alonsoPositionBet == -2){
          return Container(
            child: Text("Alonso no terminó la carrera o no tiene posición asignada"),
          );
        }

        if(races[0].resultsRaces.sainzPositionBet == -2){
          return Container(
            child: Text("Sainz no terminó la carrera o no tiene posición asignada"),
          );
        }

        return Container(
          child: Column(children: [Text("Resultados de la carrera: Alonso: ${races[0].resultsRaces.alonsoPositionBet}, Sainz: ${races[0].resultsRaces.sainzPositionBet}"),
          Tableresults(results: races[0])
          ],)
        );
      },
    );
  }
}
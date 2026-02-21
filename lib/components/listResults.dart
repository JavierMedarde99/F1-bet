import 'package:f1/components/resultF1.dart';
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
    results =
        Future.wait([
          getResults(widget.meetingKey),
          getBetsForMeeting(widget.meetingKey.toString()),
        ]).then((results) {
          return [
            Results(
              resultsRaces: results[0] as ResultsRaces,
              resultsUser: results[1] as List<ResultsUser>,
            ),
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
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration( // gradient to red
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8B0000), 
                  Color(0xFFE10600), 
                  Color(0xFF1C1C1C), 
                ],
              ),
            ),
            child: Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        final races = snapshot.data!;

        if (races[0].resultsRaces.alonsoPositionBet == -1 ||
            races[0].resultsRaces.sainzPositionBet == -1) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration( // gradient to red
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8B0000), 
                  Color(0xFFE10600), 
                  Color(0xFF1C1C1C), 
                ],
              ),
            ),
            child: Center(
              child: Text(
                "No hay resultados disponibles",
                style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        if (races[0].resultsRaces.alonsoPositionBet == -2) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration( // gradient to red
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8B0000), 
                  Color(0xFFE10600), 
                  Color(0xFF1C1C1C), 
                ],
              ),
            ),
            child: Center(
              child: Text(
                "Alonso no terminó la carrera o no tiene posición asignada",
                style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        if (races[0].resultsRaces.sainzPositionBet == -2) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration( // gradient to red
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8B0000), 
                  Color(0xFFE10600), 
                  Color(0xFF1C1C1C), 
                ],
              ),
            ),
            child: Center(
              child: Text(
                "Sainz no terminó la carrera o no tiene posición asignada",
                style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        if(races[0].resultsUser.isEmpty){
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration( // gradient to red
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8B0000), 
                  Color(0xFFE10600), 
                  Color(0xFF1C1C1C), 
                ],
              ),
            ),
            child: Center(
              child: Text(
                "No hay apuestas en esta carrera, no pierde nadie",
                style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient( // gradient to red
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8B0000), 
                Color(0xFFE10600), 
                Color(0xFF1C1C1C),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Resultf1(
                alonsoPosition: races[0].resultsRaces.alonsoPositionBet
                    .toString(),
                sainzPosition: races[0].resultsRaces.sainzPositionBet
                    .toString(),
              ),
              Tableresults(results: races[0]),
            ],
          ),
        );
      },
    );
  }
}

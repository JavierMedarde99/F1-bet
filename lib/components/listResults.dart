import 'package:f1/components/error_retry.dart';
import 'package:f1/components/resultF1.dart';
import 'package:f1/components/tableResults.dart';
import 'package:f1/models/results.dart';
import 'package:f1/models/resultsRaces.dart';
import 'package:f1/models/resultsUser.dart';
import 'package:f1/utils/connectionDataBase.dart';
import 'package:f1/utils/f1Api.dart';
import 'package:f1/utils/theme.dart';
import 'package:flutter/material.dart';

class ListResults extends StatefulWidget {
  final int meetingKey;
  ListResults({required this.meetingKey});

  @override
  _ListResultsState createState() => _ListResultsState();
}

class _ListResultsState extends State<ListResults> {
  late Future<List<Results>> results;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  // Carga (o recarga) los resultados de la carrera
  void _loadResults() {
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

  // Pantalla de mensaje unificada sobre fondo carbón
  Widget _screenMessage(String message) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: GridColors.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(GridSpacing.margin),
          child: Text(
            message.toUpperCase(),
            textAlign: TextAlign.center,
            style: GridTypography.headlineLgMobile(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Results>>(
      future: results,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: GridColors.surface,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Errorretry(
            message: "Error: ${snapshot.error}",
            onRetry: () async {
              setState(() {
                _loadResults();
              });
            },
          );
        }

        final races = snapshot.data!;

        if (races[0].resultsRaces.alonsoPositionBet == -1 ||
            races[0].resultsRaces.sainzPositionBet == -1) {
          return _screenMessage("No hay resultados disponibles");
        }

        if (races[0].resultsRaces.alonsoPositionBet == -2) {
          return _screenMessage(
            "Alonso no terminó la carrera o no tiene posición asignada",
          );
        }

        if (races[0].resultsRaces.sainzPositionBet == -2) {
          return _screenMessage(
            "Sainz no terminó la carrera o no tiene posición asignada",
          );
        }

        if (races[0].resultsUser.isEmpty) {
          return _screenMessage(
            "No hay apuestas en esta carrera, no pierde nadie",
          );
        }

        return Container(
          color: GridColors.surface,
          child: Column(
            children: [
              const SizedBox(height: GridSpacing.margin),
              ResultF1(
                alonsoPosition: races[0].resultsRaces.alonsoPositionBet
                    .toString(),
                sainzPosition: races[0].resultsRaces.sainzPositionBet
                    .toString(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: TableResults(results: races[0]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

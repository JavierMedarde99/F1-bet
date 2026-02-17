import 'dart:convert';
import 'package:f1/models/cicuits.dart';
import 'package:f1/models/resultsRaces.dart';
import 'package:f1/utils/constants.dart';
import 'package:http/http.dart' as http;



Future<List<Circuit>> getCircuits() async {

  DateTime testDate = DateTime(2025, 3, 31); // Cambia esta fecha para probar diferentes escenarios
  String testYear = "2025";

  String url = URL_CIRCUITS + testYear;

  final response = await http.get(Uri.parse(url));

  JsonDecoder decoder = const JsonDecoder();
  List<Circuit> circuits = [];
  if (response.statusCode == 200) {
    var data = decoder.convert(response.body);
    for (var circuit in data) {
      if (filterCircuits(
        circuit['meeting_name'],
        DateTime.parse(circuit['date_end']),
      )) {
        int diference = DateTime.parse(
          circuit['date_end'],
        ).difference(testDate).inDays;

        if (diference <= 0) {
          circuits.add(
            Circuit(
              circuit['meeting_name'],
              circuit['country_flag'],
              circuit['meeting_key'],
              CircuitsState.result,
            ),
          );
        } else if (diference < 7 && diference >= 3) {
          circuits.add(
            Circuit(
              circuit['meeting_name'],
              circuit['country_flag'],
              circuit['meeting_key'],
              CircuitsState.bet,
            ),
          );
        } else {
          circuits.add(
            Circuit(
              circuit['meeting_name'],
              circuit['country_flag'],
              circuit['meeting_key'],
              CircuitsState.future,
            ),
          );
        }
      }
    }
  } else {
    throw Exception('Failed to load circuits');
  }

  return circuits;
}

bool filterCircuits(String name, DateTime dateRaces) {
  return !name.contains('Pre-Season');
}

Future<ResultsRaces> getResults(int meetingKey) async {
  int sessionId = await getRace(meetingKey);
  int alonsoPosition = await getResultsByDriver(sessionId.toString(), ALONSO_ID);
  int sainzPosition = await getResultsByDriver(sessionId.toString(), SAINZ_ID);


  return 
    ResultsRaces(
      alonsoPositionBet: alonsoPosition,
      sainzPositionBet: sainzPosition,
    );
}

Future<int> getResultsByDriver(String sessionId, int driverId) async {
    String url = URL_RESULTS.replaceAll("{driverId}", driverId.toString()).replaceAll("{sessionId}", sessionId);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      JsonDecoder decoder = const JsonDecoder();
      var data = decoder.convert(response.body);
      if(data.length == 0) {
        return -1; // No hay resultados para este piloto
      }
      if(data[0]['position'] == null) {
        return -2; // El piloto no terminó la carrera o no tiene posición asignada
      }
      return data[0]['position'];
    } else {
      print("error to get results by driver: ${response.statusCode}");
      throw Exception('Failed to load results by driver');
    }
  }

Future<int> getRace(int meetingKey) async {
  String url = URL_RACES + meetingKey.toString();

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    JsonDecoder decoder = const JsonDecoder();
    var data = decoder.convert(response.body);
    return data[data.length - 1]['session_key'];
  } else {
    print("error to get races: ${response.statusCode}");
    throw Exception('Failed to load races');
  }
}

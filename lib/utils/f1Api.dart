import 'dart:convert';
import 'package:f1/models/cicuits.dart';
import 'package:f1/models/resultsRaces.dart';
import 'package:f1/utils/constants.dart';
import 'package:http/http.dart' as http;

// Obtain all the circuits for this year, obtaining only the flag, the id and the name
Future<List<Circuit>> getCircuits() async {

  String url = URL_CIRCUITS + DateTime.now().year.toString();

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
        ).difference(DateTime.now()).inDays;

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

// We removed the Preseason races because there are no bets on those types of races.
bool filterCircuits(String name, DateTime dateRaces) {
  return !name.contains('Pre-Season');
}

// We obtain the final position of Alonso and Sains
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

// We obtain the final position of a driver
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

// We obtain the race ID
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

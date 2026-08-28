import 'dart:convert';
import 'package:f1/models/circuits.dart';
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
        // La fecha máxima para apostar es el jueves de la semana de la carrera.
        // La carrera (date_end) suele ser el domingo, por lo que el jueves
        // equivale a date_end - 3 días. A partir del viernes pasa a RESULTADOS.
        final dateEnd = DateTime.parse(circuit['date_end']);
        final jueves = dateEnd.subtract(const Duration(days: 3));
        final int difference = _daysFromToday(jueves);

        if (difference < 0) {
          circuits.add(
            Circuit(
              circuit['meeting_name'],
              circuit['country_flag'],
              circuit['meeting_key'],
              CircuitsState.result,
              dateEnd: dateEnd,
            ),
          );
        } else if (difference < 7) {
          circuits.add(
            Circuit(
              circuit['meeting_name'],
              circuit['country_flag'],
              circuit['meeting_key'],
              CircuitsState.bet,
              dateEnd: dateEnd,
            ),
          );
        } else {
          circuits.add(
            Circuit(
              circuit['meeting_name'],
              circuit['country_flag'],
              circuit['meeting_key'],
              CircuitsState.future,
              dateEnd: dateEnd,
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

// Días desde hoy hasta [date], normalizando ambos a medianoche.
// Devuelve un valor negativo si [date] ya pasó hoy.
int _daysFromToday(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(date.year, date.month, date.day);
  return day.difference(today).inDays;
}

// We removed the Preseason races because there are no bets on those types of races.
bool filterCircuits(String name, DateTime dateRaces) {
  return !name.contains('Pre-Season');
}

// We obtain the final position of Alonso and Sains
Future<ResultsRaces> getResults(int meetingKey) async {
  int sessionId = await getRace(meetingKey);
  int alonsoPosition = await getResultsByDriver(
    sessionId.toString(),
    ALONSO_ID,
  );
  int sainzPosition = await getResultsByDriver(sessionId.toString(), SAINZ_ID);

  return ResultsRaces(
    alonsoPositionBet: alonsoPosition,
    sainzPositionBet: sainzPosition,
  );
}

// We obtain the final position of a driver
Future<int> getResultsByDriver(String sessionId, int driverId) async {
  String url = URL_RESULTS
      .replaceAll("{driverId}", driverId.toString())
      .replaceAll("{sessionId}", sessionId);
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    JsonDecoder decoder = const JsonDecoder();
    var data = decoder.convert(response.body);
    if (data.length == 0) {
      return -1; // No hay resultados para este piloto
    }
    if (data[0]['position'] == null) {
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
    if (data.isEmpty) {
      throw Exception('No sessions found for meeting $meetingKey');
    }
    return data[data.length - 1]['session_key'];
  } else {
    print("error to get races: ${response.statusCode}");
    throw Exception('Failed to load races');
  }
}

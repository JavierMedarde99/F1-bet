import 'dart:convert';
import 'package:f1/models/cicuits.dart';
import 'package:http/http.dart' as http;

const URL_CIRCUITS = 'https://api.openf1.org/v1/meetings?year=';
const URL_RACES = "https://api.openf1.org/v1/sessions?meeting_key=";

Future<List<Circuit>> getCircuits() async {

  DateTime testDate = DateTime(2026, 3, 2); // Cambia esta fecha para probar diferentes escenarios

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
        ).difference(testDate).inDays;
        int sessionId = await getRace(circuit['meeting_key']);

print(diference);

        if (diference < 0) {
          circuits.add(
            Circuit(
              circuit['meeting_name'],
              circuit['country_flag'],
              sessionId,
              CircuitsState.result,
            ),
          );
        } else if (diference < 7 && diference >= 3) {
          circuits.add(
            Circuit(
              circuit['meeting_name'],
              circuit['country_flag'],
              sessionId,
              CircuitsState.bet,
            ),
          );
        } else {
          circuits.add(
            Circuit(
              circuit['meeting_name'],
              circuit['country_flag'],
              sessionId,
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
  DateTime now = DateTime.now();
  int nextMonth = now.month == 12 ? 1 : now.month + 1;
  int nextMonthYear = now.month == 12 ? now.year + 1 : now.year;
  int previousMonth = now.month == 1 ? 12 : now.month - 1;
  int previousMonthYear = now.month == 1 ? now.year - 1 : now.year;
  return !name.contains('Pre-Season') &&
          (dateRaces.month == now.month && dateRaces.year == now.year) ||
      (dateRaces.month == nextMonth && dateRaces.year == nextMonthYear) ||
      (dateRaces.month == previousMonth && dateRaces.year == previousMonthYear);
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

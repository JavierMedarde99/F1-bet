import 'dart:async';
import 'dart:convert';
import 'package:f1/models/circuits.dart';
import 'package:f1/models/resultsRaces.dart';
import 'package:f1/utils/constants.dart';
import 'package:http/http.dart' as http;

// Marca que identifica el bloqueo de OpenF1 durante una sesión de F1 en directo.
const String _liveF1SessionMarker = 'Live F1 session in progress';

// Excepción lanzada cuando la API de OpenF1 está temporalmente no disponible
// (por ejemplo, bloqueada durante una sesión en directo).
class ApiUnavailableException implements Exception {
  final String message;
  const ApiUnavailableException(this.message);

  @override
  String toString() => message;
}

// Si la respuesta HTTP es un 401 por sesión en directo, lanza
// ApiUnavailableException; en caso contrario devuelve la respuesta sin cambios.
http.Response _checkLiveSessionBlock(http.Response response) {
  if (response.statusCode == 401 &&
      response.body.contains(_liveF1SessionMarker)) {
    throw const ApiUnavailableException(
      'La API de F1 no está disponible temporalmente. Espera a que termine la '
      'sesión de F1 en directo para ingresar.',
    );
  }
  return response;
}

// Realiza una petición GET con un límite de espera para evitar que la app se
// quede esperando indefinidamente si la API de OpenF1 no responde.
Future<http.Response> _getWithTimeout(String url) async {
  try {
    return await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
  } on TimeoutException {
    throw Exception(
      'La API de F1 no responde a tiempo. Inténtalo de nuevo más tarde.',
    );
  }
}

// Obtain all the circuits for this year, obtaining only the flag, the id and the name
Future<List<Circuit>> getCircuits() async {
  String url = URL_CIRCUITS + DateTime.now().year.toString();

  final response = _checkLiveSessionBlock(await _getWithTimeout(url));

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
        final dateEnd = DateTime.parse(circuit['date_end']).toUtc();
        final jueves = dateEnd.subtract(const Duration(days: 3));
        final int difference = daysFromToday(jueves);

        circuits.add(
          Circuit(
            circuit['meeting_name'],
            circuit['country_flag'],
            circuit['meeting_key'],
            classifyCircuitState(difference),
            dateEnd: dateEnd,
          ),
        );
      }
    }
  } else {
    throw Exception('Failed to load circuits');
  }

  return circuits;
}

// Días desde hoy hasta [date], normalizando ambos a medianoche UTC para que
// la clasificación no dependa de la zona horaria del dispositivo.
// Devuelve un valor negativo si [date] ya pasó hoy.
int daysFromToday(DateTime date) {
  final now = DateTime.now().toUtc();
  final today = DateTime.utc(now.year, now.month, now.day);
  final day = DateTime.utc(date.year, date.month, date.day);
  return day.difference(today).inDays;
}

// Clasifica una carrera según los días que faltan para el cierre de apuestas
// (el jueves de la semana de la carrera): negativo = ya disputada
// (resultados), menos de una semana = apuestas abiertas, el resto = futura.
CircuitsState classifyCircuitState(int daysUntilClose) {
  if (daysUntilClose < 0) {
    return CircuitsState.result;
  }
  if (daysUntilClose < 7) {
    return CircuitsState.bet;
  }
  return CircuitsState.future;
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
  final response = _checkLiveSessionBlock(await _getWithTimeout(url));
  if (response.statusCode == 200) {
    JsonDecoder decoder = const JsonDecoder();
    return parseDriverPosition(decoder.convert(response.body));
  } else {
    print("error to get results by driver: ${response.statusCode}");
    throw Exception('Failed to load results by driver');
  }
}

// Interpreta la respuesta de resultados de un piloto:
// -1 si no hay datos, -2 si no terminó (posición nula), o la posición final.
int parseDriverPosition(Object? decoded) {
  final data = decoded as List<dynamic>;
  if (data.isEmpty) {
    return -1; // No hay resultados para este piloto
  }
  final position = data[0]['position'];
  if (position == null) {
    return -2; // El piloto no terminó la carrera o no tiene posición asignada
  }
  return position as int;
}

// We obtain the race ID
Future<int> getRace(int meetingKey) async {
  String url = URL_RACES + meetingKey.toString();

  final response = _checkLiveSessionBlock(await _getWithTimeout(url));
  if (response.statusCode == 200) {
    JsonDecoder decoder = const JsonDecoder();
    var data = decoder.convert(response.body);
    if (data.isEmpty) {
      throw Exception('No sessions found for meeting $meetingKey');
    }
    return parseRaceSessionKey(data);
  } else {
    print("error to get races: ${response.statusCode}");
    throw Exception('Failed to load races');
  }
}

// Devuelve la session_key de la carrera: la última sesión del meeting
// (las anteriores son libres, clasificación, sprint...).
int parseRaceSessionKey(List<dynamic> data) {
  return data[data.length - 1]['session_key'] as int;
}

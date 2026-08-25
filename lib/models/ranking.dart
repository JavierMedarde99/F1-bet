/// Usuario en la clasificación de pérdidas acumuladas.
class RankingUser {
  final String name;
  final int totalLosses;
  final int racesCount;

  const RankingUser({
    required this.name,
    required this.totalLosses,
    required this.racesCount,
  });

  /// Media de posiciones falladas por carrera disputada.
  double get averageLoss => racesCount == 0 ? 0 : totalLosses / racesCount;
}

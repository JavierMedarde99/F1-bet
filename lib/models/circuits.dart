enum CircuitsState { result, bet, future }

class Circuit {
  final String name;
  final String imagen;
  final int meetingId;
  final CircuitsState state;
  final DateTime dateEnd;
  const Circuit(
    this.name,
    this.imagen,
    this.meetingId,
    this.state, {
    required this.dateEnd,
  });
}

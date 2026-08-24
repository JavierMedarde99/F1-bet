enum CircuitsState { result, bet, future }

class Circuit {
  final String name;
  final String imagen;
  final int meetingId;
  final CircuitsState state;
  const Circuit(this.name, this.imagen, this.meetingId, this.state);
}

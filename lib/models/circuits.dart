enum CircuitsState { result, bet, future }

class Circuit {
  String name;
  String imagen;
  int meetingId;
  CircuitsState state;
  Circuit(this.name, this.imagen, this.meetingId, this.state);
}

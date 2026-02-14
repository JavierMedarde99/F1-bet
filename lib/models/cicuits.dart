enum CircuitsState { result, bet, future }

class Circuit {
  String name;
  String imagen;
  int sessionId;
  CircuitsState state;
  Circuit(this.name, this.imagen, this.sessionId, this.state);
}

import 'package:flutter/material.dart';
import 'package:f1/utils/connectionDataBase.dart';

class FromBet extends StatefulWidget {
  final int userId;
  final String meetingId;

  const FromBet({
    Key? key,
    required this.userId,
    required this.meetingId,
  }) : super(key: key);

  @override
  State<FromBet> createState() => _FromBetState();
}

class _FromBetState extends State<FromBet> {
  final TextEditingController betAlonso = TextEditingController();
  final TextEditingController betSainz = TextEditingController();

  bool _isExists = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkIfBetExists();
  }

  Future<void> _checkIfBetExists() async {

    
      Map<String, dynamic>? bet = await getBetForMeetingAndUser(widget.userId, widget.meetingId);

      if (bet != null) {
        int? positionAlonso = bet['alonso_position'];
        int? positionSainz = bet['sainz_position'];

        if (positionAlonso != null) {
          betAlonso.text = positionAlonso.toString();
        }

        if (positionSainz != null) {
          betSainz.text = positionSainz.toString();
        }
      }
    

    setState(() {
      _isExists = bet != null;
      _isLoading = false;
    });
  }

  Future<void> _submitBet() async {
    if (betAlonso.text.isEmpty || betSainz.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes rellenar ambos campos')),
      );
      return;
    }

    int alonsoPosition = int.tryParse(betAlonso.text) ?? 0;
    int sainzPosition = int.tryParse(betSainz.text) ?? 0;

    bool success = await sendBet(
      widget.userId,
      widget.meetingId,
      alonsoPosition,
      sainzPosition,
      _isExists
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? _isExists
                  ? 'Apuesta actualizada con éxito'
                  : 'Apuesta enviada con éxito'
              : 'Error al enviar la apuesta',
        ),
      ),
    );

    if (success) {
      setState(() {
        _isExists = true;
      });
    }
  }

  @override
  void dispose() {
    betAlonso.dispose();
    betSainz.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        TextField(
          controller: betAlonso,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Posición de Alonso',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: betSainz,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Posición de Sainz',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _submitBet,
          child: Text(_isExists ? 'Actualizar Apuesta' : 'Enviar Apuesta'),
        ),
      ],
    );
  }
}

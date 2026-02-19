import 'package:f1/components/cardPage.dart';
import 'package:flutter/material.dart';
import 'package:f1/utils/connectionDataBase.dart';

class FromBet extends StatefulWidget {
  final int userId;
  final String meetingId;

  const FromBet({Key? key, required this.userId, required this.meetingId})
    : super(key: key);

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
    Map<String, dynamic>? bet = await getBetForMeetingAndUser(
      widget.userId,
      widget.meetingId,
    );

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
      _isExists,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: success ? Colors.green : Colors.red,
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

    return Container(
      color: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        
          Cardpage(
              image: Image.asset('assets/images/alonso.jpg'),
              text: "apuesta a alonso",
              container: Container(child: TextField(
                  controller: betAlonso,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Posición",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),),
            ),

            Cardpage(
              image: Image.asset('assets/images/sainz.jpg'),
              text: "apuesta a sainz",
              container: Container(child: TextField(
                  controller: betSainz,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Posición",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),),
            ),

          /// 🚀 BOTÓN
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _submitBet,
              child: Text(
                _isExists ? 'Actualizar Apuesta' : 'Enviar Apuesta',
                style: const TextStyle(fontSize: 16,color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

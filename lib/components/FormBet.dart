import 'package:f1/utils/connectionDataBase.dart';
import 'package:f1/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormBet extends StatefulWidget {
  final int userId;
  final String meetingId;

  const FormBet({Key? key, required this.userId, required this.meetingId})
    : super(key: key);

  @override
  State<FormBet> createState() => _FormBetState();
}

class _FormBetState extends State<FormBet> {
  final TextEditingController betAlonso = TextEditingController();
  final TextEditingController betSainz = TextEditingController();

  bool _isExists = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkIfBetExists();
  }

  // We check the database to see if there is already a saved bet
  Future<void> _checkIfBetExists() async {
    Map<String, dynamic>? bet = await getBetForMeetingAndUser(
      widget.userId,
      widget.meetingId,
    );

    if (!mounted) return;

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

  // We send the data to the database, either to insert it or to update it.
  Future<void> _submitBet() async {
    if (betAlonso.text.isEmpty || betSainz.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes rellenar ambos campos')),
      );
      return;
    }

    int alonsoPosition = int.tryParse(betAlonso.text) ?? 0;
    int sainzPosition = int.tryParse(betSainz.text) ?? 0;

    // En F1 solo hay 20 pilotos: la posición válida es 1-20
    if (alonsoPosition < 1 ||
        alonsoPosition > 20 ||
        sainzPosition < 1 ||
        sainzPosition > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las posiciones deben estar entre 1 y 20'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

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
        backgroundColor: success ? GridColors.limeDim : GridColors.rossoCorsa,
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

  // Módulo split de piloto: imagen + input subrayado, borde de acento lima/rosso
  Widget _driverModule({
    required String asset,
    required String label,
    required Color accent,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.all(GridSpacing.gutter),
      decoration: BoxDecoration(
        color: GridColors.containerLow,
        border: Border(
          left: BorderSide(color: accent, width: 4),
          top: const BorderSide(color: GridColors.outlineVariant),
          right: const BorderSide(color: GridColors.outlineVariant),
          bottom: const BorderSide(color: GridColors.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(
              asset,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.person, size: 64, color: accent);
              },
            ),
          ),
          const SizedBox(width: GridSpacing.gutter),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label.toUpperCase(), style: GridTypography.labelCaps()),
                const SizedBox(height: GridSpacing.unit * 3),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 2,
                  style: GridTypography.oddsLg(),
                  decoration: const InputDecoration(hintText: 'POSICIÓN'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // betting form
    return Container(
      color: GridColors.surface,
      padding: const EdgeInsets.all(GridSpacing.margin),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _driverModule(
            asset: 'assets/images/alonso.jpg',
            label: "Apuesta a Alonso",
            accent: GridColors.lime,
            controller: betAlonso,
          ),

          _driverModule(
            asset: 'assets/images/sainz.jpg',
            label: "Apuesta a Sainz",
            accent: GridColors.rossoCorsa,
            controller: betSainz,
          ),

          // button send bet
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitBet,
              child: Text(_isExists ? 'ACTUALIZAR APUESTA' : 'ENVIAR APUESTA'),
            ),
          ),
        ],
      ),
    );
  }
}

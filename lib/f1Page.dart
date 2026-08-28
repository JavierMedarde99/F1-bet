import 'package:f1/components/listRaces.dart';
import 'package:f1/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//main page
class F1page extends StatelessWidget {
  final int userId;
  F1page({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.flagCheckered,
              size: 20,
              color: GridColors.lime,
            ),
            const SizedBox(width: 12),
            const Text('F1 ALL RACES'),
          ],
        ),
        actions: [
          // Chip del año en curso con borde lima
          Container(
            margin: const EdgeInsets.only(right: GridSpacing.gutter),
            padding: const EdgeInsets.symmetric(
              horizontal: GridSpacing.unit * 3,
              vertical: GridSpacing.unit * 2,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: GridColors.lime),
            ),
            child: Text(
              '${DateTime.now().year}',
              style: GridTypography.dataMono(color: GridColors.lime),
            ),
          ),
        ],
      ),
      body: Center(child: ListRaces(userId: userId)),
    );
  }
}

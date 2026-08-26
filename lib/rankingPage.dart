import 'package:f1/components/error_retry.dart';
import 'package:f1/components/rankingRow.dart';
import 'package:f1/models/ranking.dart';
import 'package:f1/utils/connectionDataBase.dart';
import 'package:f1/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  late Future<List<RankingUser>> _ranking;

  @override
  void initState() {
    super.initState();
    _ranking = getRankingByLosses();
  }

  Future<void> _reload() async {
    setState(() {
      _ranking = getRankingByLosses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.skull,
              size: 18,
              color: GridColors.rossoCorsa,
            ),
            const SizedBox(width: 12),
            const Text('RANKING'),
          ],
        ),
      ),
      body: FutureBuilder<List<RankingUser>>(
        future: _ranking,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: GridColors.rossoCorsa),
            );
          }

          if (snapshot.hasError) {
            return Errorretry(message: '${snapshot.error}', onRetry: _reload);
          }

          final List<RankingUser> ranking = snapshot.data ?? [];

          if (ranking.isEmpty) {
            return Center(
              child: Text(
                'AÚN NO HAY RANKING.\n¡DISPUTA UNA CARRERA!',
                textAlign: TextAlign.center,
                style: GridTypography.headlineLgMobile(),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView.builder(
              itemCount: ranking.length,
              itemBuilder: (context, index) {
                // Empates: todos los usuarios con las pérdidas máximas
                final int topLosses = ranking.first.totalLosses;
                return RankingRow(
                  user: ranking[index],
                  position: index + 1,
                  totalRows: ranking.length,
                  isTopLoser:
                      topLosses > 0 && ranking[index].totalLosses == topLosses,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

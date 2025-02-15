import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/ReusableWidgets/loading_indicator.dart';
import 'package:tactix_academy_manager/Core/Theme/custom_scaffold.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team Database/players_database.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';
import 'package:tactix_academy_manager/View/Players/Widgets/player_card.dart';

import '../../Core/Theme/app_colours.dart';

class AllPlayers extends StatelessWidget {
  const AllPlayers({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: const Text(
          'All Players',
          style: secondaryTextTheme,
        ),
      ),
      body: FutureBuilder<List<PlayerModel>>(
        future: PlayerDatabase().getAllPlayers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoadingIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      color: mainTextColour2, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: maintexttheme,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final players = snapshot.data!;
            if (players.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_outline, size: 60, color: mainTextColour),
                    SizedBox(height: 16),
                    Text('No players found', style: maintexttheme),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  return PlayerCard(player: players[index]);
                },
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Some issue is there please check your internet and try again.',
                style: secondaryTextTheme,
              ),
            );
          }
        },
      ),
    );
  }
}

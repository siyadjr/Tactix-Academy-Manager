import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/player_details_controller.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/players_database.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';
import 'package:tactix_academy_manager/View/Players/PlayerInitialDatas/add_player_initial_details.dart';
import 'package:tactix_academy_manager/View/Players/Widgets/achivements_bottomsheet.dart';
import 'package:tactix_academy_manager/View/Players/Widgets/player_achievements_list.dart';
import 'package:tactix_academy_manager/View/Players/Widgets/player_details_widget.dart';

class PlayerDetailsPage extends StatelessWidget {
  final String playerId;

  const PlayerDetailsPage({required this.playerId, super.key});

  @override
  Widget build(BuildContext context) {
    final playerDetailsProvider =
        Provider.of<PlayerDetailsController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (playerDetailsProvider.player?.id != playerId) {
        playerDetailsProvider.fetchData(playerId);
      }
    });

    return Scaffold(
      backgroundColor: backGroundColor,
      body: Consumer<PlayerDetailsController>(
        builder: (context, value, child) => FutureBuilder<PlayerModel>(
          future: PlayerDatabase().getPlayerDetails(playerId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Error loading player details.',
                  style: TextStyle(color: mainTextColour2),
                ),
              );
            } else if (snapshot.hasData) {
              final player = snapshot.data!;
              return CustomScrollView(
                slivers: [
                  _buildSliverAppBar(context, player),
                  SliverToBoxAdapter(
                    child: _buildPlayerDetails(context, player),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text(
                  'Player not found.',
                  style: TextStyle(color: mainTextColour),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, PlayerModel player) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: backGroundColor,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit, color: iconColour),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => AddPlayerInitialDetails(
                          player: player,
                          pop: true,
                        )));
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'player-${player.name}',
              child: Image.network(
                player.userProfile,
                fit: BoxFit.cover,
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    backGroundColor.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    player.name,
                    style: const TextStyle(
                      color: secondTextColour,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      buildInfoChip(Icons.sports_soccer, player.position),
                      const SizedBox(width: 8),
                      buildInfoChip(Icons.star, 'Rank ${player.rank}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerDetails(BuildContext context, PlayerModel player) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildStatsSection(player),
          const SizedBox(height: 24),
          PlayerAchievementsList(
            player: player,
          ),
        ],
      ),
    );
  }
}

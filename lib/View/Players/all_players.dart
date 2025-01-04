import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/custom_scaffold.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team Database/players_database.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';

import '../../Core/Theme/app_colours.dart';

class AllPlayers extends StatelessWidget {
  const AllPlayers({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: FutureBuilder<List<PlayerModel>>(
        future: PlayerDatabase().getAllPlayers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: mainTextColour,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: mainTextColour2,
                    size: 60,
                  ),
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
                    Icon(
                      Icons.people_outline,
                      size: 60,
                      color: mainTextColour,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No players found',
                      style: maintexttheme,
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  return Card(
                    color: Colors.black,
                    elevation: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Handle player selection
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Hero(
                              tag: 'player-${player.name}',
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(player.userProfile),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    player.name,
                                    style: maintexttheme.copyWith(
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _buildInfoChip(
                                        Icons.sports_soccer,
                                        player.position,
                                      ),
                                      const SizedBox(width: 8),
                                      _buildInfoChip(
                                        Icons.star,
                                        '${player.rank}',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _buildStatistic(
                                        'Goals',
                                        player.goals.toString(),
                                      ),
                                      const SizedBox(width: 24),
                                      _buildStatistic(
                                        'Assists',
                                        player.assists.toString(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Unexpected error occurred.',
                style: secondaryTextTheme,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: mainTextColour.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: mainTextColour),
          const SizedBox(width: 4),
          Text(
            label,
            style: secondaryTextTheme.copyWith(
              fontSize: 14,
              color: mainTextColour,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistic(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: secondaryTextTheme.copyWith(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: secondaryTextTheme.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ],
    );
  }
}



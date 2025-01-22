import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/player_details_controller.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/team_database.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';

class PlayerDatabase {
  Future<List<PlayerModel>> getAllPlayers() async {
    try {
      // Fetch the team ID
      final teamId = await TeamDatabase().getTeamId();
      log('Fetched teamId: $teamId');

      // Get the team document
      final teamDoc = await FirebaseFirestore.instance
          .collection('Teams')
          .doc(teamId)
          .get();

      if (!teamDoc.exists) {
        log('Team document does not exist for teamId: $teamId');
        return [];
      }

      // Extract the players array from the team document
      final playersArray = List<String>.from(teamDoc.data()?['players'] ?? []);
      if (playersArray.isEmpty) {
        log('No players found for teamId: $teamId');
        return [];
      }

      log('Player IDs: $playersArray');

      // Fetch each player from the Players collection
      List<PlayerModel> players = [];
      for (String playerId in playersArray) {
        log('Fetching details for playerId: $playerId');
        final playerDetails = await getPlayerDetails(playerId);
        players.add(playerDetails);
      }

      return players;
    } catch (e) {
      // Handle errors
      log('Error fetching players: $e');
      return [];
    }
  }

  Future<PlayerModel> getPlayerDetails(String id) async {
    try {
      log('Fetching player details for ID: $id');
      final playerDoc =
          await FirebaseFirestore.instance.collection('Players').doc(id).get();

      if (playerDoc.exists) {
        log('Player document exists for ID: $id');
        final data = playerDoc.data()!;

        return PlayerModel(
          id: id,
          name: data['name'] ?? 'Unknown', // String
          email: data['email'] ?? 'No email', // String
          fit: data['fit'] ?? 'unfit', // bool
          matches: data['matches'] ?? '0',
          achivements: data['achivements'] ?? [],
          goals: data['goals'] ?? '0', // int
          assists: data['assists'] ?? '0', // int
          number: (data['number']) ?? '0', // int
          position: data['position'] ?? 'Unknown', // String
          rank: data['rank'] ?? 'Unranked', // String
          teamId: data['teamId'] ?? '', // String
          userProfile: data['userProfile'] ?? '', // String
        );
      } else {
        log('Player document does not exist for ID: $id');
        throw Exception('Player not found');
      }
    } catch (e) {
      log('Error fetching player details for ID $id: $e');
      throw e;
    }
  }

  Future<void> addPlayerDetails(PlayerModel player) async {
    await FirebaseFirestore.instance
        .collection('Players')
        .doc(player.id)
        .update({
      'goals': player.goals,
      'number': player.number,
      'matches': player.matches,
      'assists': player.assists,
      'achivements': player.achivements,
      //  'achivements':player.achivements,
      'position': player.position
    });
  }

  Future<void> addPlayerAchievement(
      String playerId, String name, String count) async {
    try {
      await FirebaseFirestore.instance
          .collection('Players')
          .doc(playerId)
          .update({
        'achivements': FieldValue.arrayUnion([
          {'name': name, 'count': count}
        ]),
      });
      print("Achievement added successfully!");
    } catch (e) {
      print("Error adding achievement: $e");
    }
  }

  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> AlertBox to edit Achievments>>>>>>>>>>>>>>>>>>>>>>>>>>>

  void showOptionsDialog(BuildContext context, Map<String, dynamic> achievement,
      PlayerModel player, int index) {
    // Controllers for text fields
    final nameController = TextEditingController(text: achievement['name']);
    final countController =
        TextEditingController(text: achievement['count'].toString());

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: backGroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: mainTextColour.withOpacity(0.2),
              width: 1,
            ),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: mainTextColour.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: iconColour,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Manage Achievement",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Achievement Name",
                  style: TextStyle(
                    color: secondTextColour,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: primaryColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: mainTextColour.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Enter achievement name",
                    hintStyle: TextStyle(color: primaryColor.withOpacity(0.5)),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Count",
                  style: TextStyle(
                    color: secondTextColour,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: countController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: primaryColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: mainTextColour.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Enter count",
                    hintStyle: TextStyle(color: primaryColor.withOpacity(0.5)),
                    prefixIcon: Icon(
                      Icons.star,
                      color: iconColour.withOpacity(0.7),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                player.achivements.removeAt(index);
                PlayerDatabase().addPlayerDetails(player);
                context.read<PlayerDetailsController>().fetchData(player.id);

                Navigator.pop(context);
              },
              icon:
                  const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              label: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                String name = nameController.text.trim();
                int count = int.tryParse(countController.text) ?? 0;

                if (name.isEmpty || count < 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        name.isEmpty
                            ? "Achievement name cannot be empty!"
                            : "Count must be at least 1!",
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return; // Stop execution
                }

                player.achivements[index] = {
                  'name': name,
                  'count': count,
                };
                PlayerDatabase().addPlayerDetails(player);
                context.read<PlayerDetailsController>().fetchData(player.id);

                Navigator.pop(context);
              },
              icon:
                  const Icon(Icons.save_outlined, color: Colors.blue, size: 20),
              label: const Text(
                "Save",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        );
      },
    );
  }
}

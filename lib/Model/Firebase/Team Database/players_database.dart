import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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
          fit: data['fit'] ?? false, // bool
          goals: data['goals'] ?? '0', // int
          assists: data['assists'] ?? '0', // int
          number: (data['number'] is int)
              ? data['number']
              : int.tryParse(data['number'] ?? '0') ?? '0', // int
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
}

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/team_database.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';

class JoinRequestsDb {
  Future<List<PlayerModel>> fetchRequestedPlayersId() async {
    List<PlayerModel> players = [];
    try {
      // Fetch team ID
      final String teamId = await TeamDatabase().getTeamId();

      // Fetch the team data from Firestore
      final DocumentSnapshot teamData = await FirebaseFirestore.instance
          .collection('Teams')
          .doc(teamId)
          .get();

      // Extract the player requests (list of player IDs)
      if (teamData.exists && teamData.data() != null) {
        final playersData = teamData['playersRequests'] as List<dynamic>;

        // Log the fetched player IDs
        log('Player IDs: $playersData');

        // Fetch player details for each ID
        for (var playerId in playersData) {
          final userId = playerId['userId'];
          final playerDetails = await fetchJoinReqPlayerDetails(userId, teamId);
          players.add(playerDetails);
        }
      }
    } catch (e) {
      log('Error fetching requested players: $e');
    }
    return players;
  }

  Future<PlayerModel> fetchJoinReqPlayerDetails(
      String playerId, String teamId) async {
    try {
      // Fetch player data from Firestore
      final DocumentSnapshot playerData = await FirebaseFirestore.instance
          .collection('Players')
          .doc(playerId)
          .get();

      if (playerData.exists && playerData.data() != null) {
        // Map Firestore data to PlayerModel
        log('The user name is : ${playerData['name']}');
        return PlayerModel(
          id: playerId,
          name: playerData['name'] ?? '',
          email: playerData['email'] ?? '',
          fit: playerData['fit'] ?? '0',
          goals: playerData['goals'] ?? '0',
          assists: playerData['assists'] ?? '0',
          number: playerData['number'] ?? '0',
          position: playerData['position'] ?? '',
          rank: playerData['rank'] ?? '0',
          teamId: teamId,
          userProfile: playerData['userProfile'] ?? '',
        );
      } else {
        throw Exception('Player data not found for ID: $playerId');
      }
    } catch (e) {
      log('Error fetching player details for $playerId: $e');
      rethrow;
    }
  }
}

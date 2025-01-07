import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  Future<void> approveRequest(
      BuildContext context, String teamId, String userId) async {
    try {
      final teamDoc =
          FirebaseFirestore.instance.collection('Teams').doc(teamId);

      FirebaseFirestore.instance
          .collection('Players')
          .doc(userId)
          .update({'teamId': teamId});
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot teamSnapshot = await transaction.get(teamDoc);

        if (teamSnapshot.exists) {
          List<dynamic> requests = teamSnapshot.get('playersRequests') ?? [];
          log(requests.toString());
          requests.removeWhere((request) => request['userId'] == userId);

          transaction.update(teamDoc, {'playersRequests': requests});
        }
      });
      await teamDoc.update({
        'players': FieldValue.arrayUnion([userId]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request approved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error approving request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error approving request: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> declineRequest(
      BuildContext context, String teamId, String userId) async {
    try {
      final teamDoc =
          FirebaseFirestore.instance.collection('Teams').doc(teamId);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot teamSnapshot = await transaction.get(teamDoc);

        if (teamSnapshot.exists) {
          List<dynamic> playersRequests =
              teamSnapshot.get('playersRequests') ?? [];
          log(playersRequests.toString());
          log('next is ${playersRequests.first['userId']}');
          playersRequests.removeWhere((user) => user['userId'] == userId);

          transaction.update(teamDoc, {'playersRequests': playersRequests});
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
              child: Text(
            'Request declined successfully!',
            textAlign: TextAlign.center,
          )),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      log("Error declining request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error declining request: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

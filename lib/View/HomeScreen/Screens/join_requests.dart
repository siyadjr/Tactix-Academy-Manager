import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/join_requests_db.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';

class JoinRequests extends StatelessWidget {
  const JoinRequests({super.key});

  Future<void> _approveRequest(
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

  Future<void> _declineRequest(
      BuildContext context, String teamId, String userId) async {
    try {
      final teamDoc =
          FirebaseFirestore.instance.collection('Teams').doc(teamId);

      // Remove the user from playersRequests
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot teamSnapshot = await transaction.get(teamDoc);

        if (teamSnapshot.exists) {
          List<dynamic> playersRequests =
              teamSnapshot.get('playersRequests') ?? [];

          playersRequests.remove(userId);

          transaction.update(teamDoc, {'playersRequests': playersRequests});
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request declined successfully!'),
          backgroundColor: Colors.orange,
        ),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Join Requests'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<PlayerModel>>(
        future: JoinRequestsDb().fetchRequestedPlayersId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No join requests at the moment.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final players = snapshot.data!;

          return ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: player.userProfile.isNotEmpty
                        ? NetworkImage(player.userProfile)
                        : null,
                    child: player.userProfile.isEmpty
                        ? const Icon(Icons.person, size: 30)
                        : null,
                  ),
                  title: Text(
                    player.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(player.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          _approveRequest(context, player.teamId, player.id);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          _declineRequest(context, player.teamId, player.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

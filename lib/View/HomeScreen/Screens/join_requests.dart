import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/custom_scaffold.dart';

class JoinRequests extends StatelessWidget {
  const JoinRequests({super.key});

  Future<String?> _fetchTeamId() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('Managers')
            .doc(user.uid)
            .get();

        final teamId = userDoc.data()?['teamId'];
        if (teamId != null) {
          log("Team ID fetched: $teamId");
          return teamId;
        } else {
          print("Team ID is null for user: ${user.uid}");
          return null;
        }
      } else {
        print("No user logged in.");
        return null;
      }
    } catch (e) {
      print("Error fetching teamId: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _fetchTeamId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print("FutureBuilder error: ${snapshot.error}");
          return const CustomScaffold(
            body: Center(
              child: Text(
                'Error loading team data!',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          print("No teamId found in FutureBuilder.");
          return const CustomScaffold(
            body: Center(
              child: Text(
                'You are not associated with any team!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final teamId = snapshot.data!;
        print("Using teamId: $teamId");

        return CustomScaffold(
          body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Teams')
                .doc(teamId)
                .snapshots(),
            builder: (context, teamSnapshot) {
              if (teamSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (teamSnapshot.hasError) {
                print("StreamBuilder error: ${teamSnapshot.error}");
                return const Center(
                  child: Text(
                    'Error loading requests!',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }

              if (!teamSnapshot.hasData || !teamSnapshot.data!.exists) {
                print("Team document not found for ID: $teamId");
                return const Center(
                  child: Text(
                    'No requests found for this team.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final teamData =
                  teamSnapshot.data!.data() as Map<String, dynamic>;
              final requests = teamData['requests'] as List<dynamic>? ?? [];

              if (requests.isEmpty) {
                return const Center(
                  child: Text(
                    'No requests at the moment.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];

                  if (request is! Map<String, dynamic>) {
                    print("Invalid request format: $request");
                    return const SizedBox();
                  }

                  final userName = request['userName'] ?? 'Unknown';
                  final userId = request['userId'] ?? 'N/A';

                  return Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      title: Text(
                        userName,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'User ID: $userId',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          _approveRequest(context, teamId, userId);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

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
          List<dynamic> requests = teamSnapshot.get('requests') ?? [];

        
          requests.removeWhere((request) => request['userId'] == userId);

       
          transaction.update(teamDoc, {'requests': requests});
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
}

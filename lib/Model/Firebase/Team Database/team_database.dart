import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tactix_academy_manager/Core/SharedPrefernce/shared_pref_functions.dart';
import 'package:tactix_academy_manager/Model/Firebase/Authentication%20funcations/user.db.dart';
import 'package:tactix_academy_manager/Model/Models/team_full_model.dart';
import 'package:tactix_academy_manager/Model/Models/team_model.dart';

class TeamDatabase {
  String? teamId; // Dynamically updated team ID

  Future<void> createTeam(TeamModel team) async {
    try {
      // Using 'add()' to create a team with an auto-generated document ID
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('Teams').add({
        'managerId': team.managerId,
        'teamName': team.name,
        'teamLocation': team.location,
        'playersRequests': [],
        'teamPhoto': team.teamPhoto,
        'rentFee': '1'
      });

      // Update the teamId dynamically
      teamId = docRef.id;

      print('Team created successfully with ID: $teamId');

      // Update the user's team ID and shared preferences
      await UserDatbase().uploadTeamId(teamId!);
      await SharedPrefFunctions().sharePrefTeamCreated();
    } catch (e) {
      print('Error creating team: $e');
    }
  }

  Future<void> sendMessageBroadcast(String message) async {
    try {
      // Get the current user's ID
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        log('Error: No user is logged in.');
        return;
      }

      // Fetch the manager's data from Firestore
      final managerSnapshot = await FirebaseFirestore.instance
          .collection('Managers')
          .doc(user.uid)
          .get();

      if (!managerSnapshot.exists) {
        log('Error: Manager document does not exist for user ID: ${user.uid}');
        return;
      }

      // Extract the team ID from the manager's data
      final managerData = managerSnapshot.data();
      final teamId = managerData?['teamId'] as String?;
      if (teamId == null || teamId.isEmpty) {
        log('Error: teamId is missing in the manager document.');
        return;
      }

      // Log the teamId to ensure it's properly fetched
      log('Attempting to broadcast message to team: $teamId');

      // Check if the team document exists
      final teamDocSnapshot = await FirebaseFirestore.instance
          .collection('Teams')
          .doc(teamId)
          .get();

      if (!teamDocSnapshot.exists) {
        log('Error: Team document does not exist for team ID: $teamId');
        return;
      }

      // Add the message to the Broadcast subcollection
      await FirebaseFirestore.instance
          .collection('Teams')
          .doc(teamId)
          .collection('Broadcast')
          .add({
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      log('Message broadcasted successfully to team: $teamId');
    } catch (e, stackTrace) {
      log(
        'Error broadcasting message: $e',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<String> getTeamId() async {
    try {
      // Get the current user's ID
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user is logged in.');
      }

      // Fetch the manager's data from Firestore
      final managerSnapshot = await FirebaseFirestore.instance
          .collection('Managers')
          .doc(user.uid)
          .get();

      if (!managerSnapshot.exists) {
        throw Exception(
            'Manager document does not exist for user ID: ${user.uid}');
      }

      // Extract the team ID from the manager's data
      final managerData = managerSnapshot.data();
      final teamId = managerData?['teamId'] as String?;
      if (teamId == null || teamId.isEmpty) {
        throw Exception('teamId is missing in the manager document.');
      }

      log('Fetched teamId: $teamId');
      return teamId;
    } catch (e, stackTrace) {
      log(
        'Error fetching teamId: $e',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<bool> getRentPaymentEnabled() async {
    try {
      final teamId = await getTeamId();
      final snapShot = await FirebaseFirestore.instance
          .collection('Teams')
          .doc(teamId)
          .get();

      // Check if the document exists and rentEnabled field is present
      if (snapShot.exists && snapShot.data() != null) {
        final rentEnabled = snapShot.data()?['rentEnabled'] ??
            false; // Default to false if not found
        return rentEnabled;
      }
      return false; // Return false if the document doesn't exist or rentEnabled is not set
    } catch (e) {
      // Handle any errors, such as network or Firebase issues
      print('Error fetching rent payment status: $e');
      return false;
    }
  }

  Future<void> enablePayment() async {
    final teamId = await getTeamId();
    await FirebaseFirestore.instance
        .collection('Teams')
        .doc(teamId)
        .update({'rentEnabled': true});
  }

  Future<void> disablePayment() async {
    final teamId = await getTeamId();
    await FirebaseFirestore.instance
        .collection('Teams')
        .doc(teamId)
        .update({'rentEnabled': false});
  }

  Future<void> updateRentFee(String fee) async {
    final teamId = await getTeamId();
    await FirebaseFirestore.instance
        .collection('Teams')
        .doc(teamId)
        .update({'rentFee': fee});
  }

  Future<String> getPaymentFee() async {
    try {
      final teamId = await getTeamId();
      final snapShot = await FirebaseFirestore.instance
          .collection('Teams')
          .doc(teamId)
          .get();

      if (snapShot.exists && snapShot.data()!.containsKey('rentFee')) {
        final rentFee = snapShot.get('rentFee').toString(); // Convert to String
        log('Fetched rentFee: $rentFee');
        return rentFee;
      } else {
        log('rentFee not found for teamId: $teamId');
      }
    } catch (e) {
      log('Error fetching rentFee: $e');
    }

    return '0'; // Return default value
  }

  Future<TeamFullModel?> getTeamDetails() async {
    final teamId = await getTeamId();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (teamId.isNotEmpty && userId != null) {
      final snapShot = await FirebaseFirestore.instance
          .collection('Teams')
          .doc(teamId)
          .get();
      if (snapShot.exists) {
        final playersData = snapShot.data()?['players'];
        final teamData = TeamFullModel(
          id: snapShot.id,
          teamName: snapShot.data()?['teamName'],
          teamLocation: snapShot.data()?['teamLocation'],
          teamPhoto: snapShot.data()?['teamPhoto'],
          teamPlayersCount: (playersData is List) ? playersData.length : 0,
        );
        return teamData;
      }
    }
    return null;
  }

  Future<void> updateTeamLogo(String url) async {
    final teamId = await getTeamId();
    await FirebaseFirestore.instance
        .collection('Teams')
        .doc(teamId)
        .update({'teamPhoto': url});
  }

  Future<void> updateTeamLocation(String newLocation) async {
    final teamId = await getTeamId();
    await FirebaseFirestore.instance
        .collection('Teams')
        .doc(teamId)
        .update({'teamLocation': newLocation});
  }

  Future<void> updateTeamName(String newName) async {
    final teamId = await getTeamId();
    await FirebaseFirestore.instance
        .collection('Teams')
        .doc(teamId)
        .update({'teamName': newName});
  }
}

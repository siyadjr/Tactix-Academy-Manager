import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TeamProvider with ChangeNotifier {
  String _teamName = "Loading...";
  String _teamPhotoUrl = "";
  String _managerPhotoUrl = "";
  String _teamId = '';
  String get teamName => _teamName;
  String get teamPhotoUrl => _teamPhotoUrl;
  String get managerPhotoUrl => _managerPhotoUrl;
  String get teamId => _teamId;

  Future<void> fetchTeamNameAndPhoto() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      log('functioncalled !');
      if (user == null) {
        _teamName = "No User Logged In";
        _teamPhotoUrl = "";
        _managerPhotoUrl =
            "assets/default_team_logo.png"; // Local fallback for manager photo
        notifyListeners();
        return;
      }

      // Fetch user document from 'Managers' collection
      final userDoc = await FirebaseFirestore.instance
          .collection('Managers')
          .doc(user.uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        _teamName = "Team";
        _teamPhotoUrl = "";
        _managerPhotoUrl = "assets/default_team_logo.png";
        notifyListeners();
        return;
      }

      final teamId = userDoc.data()?['teamId'];
      _teamId = teamId;
      final managerProfilePhoto = userDoc.data()?['userProfile'];

      if (teamId == null) {
        _teamName = "Team ID Not Found";
        _teamPhotoUrl = "";
        _managerPhotoUrl =
            managerProfilePhoto ?? "assets/default_team_logo.png";
        notifyListeners();
        return;
      }

      // Fetch the team document using the teamId
      final teamDoc = await FirebaseFirestore.instance
          .collection('Teams')
          .doc(teamId)
          .get();

      if (teamDoc.exists && teamDoc.data() != null) {
        _teamName = teamDoc.data()?['teamName'] ?? "Unnamed Team";
        _teamPhotoUrl = teamDoc.data()?['teamPhoto'] ?? "";

        log('Fetched team photo URL: $_teamPhotoUrl');
      } else {
        _teamName = "Team Not Found";
        _teamPhotoUrl = "";
      }

      _managerPhotoUrl = managerProfilePhoto ?? "assets/default_team_logo.png";
    } catch (e) {
      _teamName = "Error Loading Team Name";
      _teamPhotoUrl = "";
      _managerPhotoUrl = "assets/default_team_logo.png";

      log("Error fetching team and manager photos: $e");
    }

    notifyListeners();
  }
}

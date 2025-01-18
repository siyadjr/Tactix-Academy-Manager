import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Controller/Controllers/add_session_controller.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/team_database.dart';
import 'package:tactix_academy_manager/Model/Models/session_model.dart';

class SessionsDatabase {
  Future<void> addSessions(SessionModel session) async {
    try {
      final teamId = await TeamDatabase().getTeamId();

      final teamDocRef =
          FirebaseFirestore.instance.collection('Teams').doc(teamId);

      await teamDocRef.collection('sessions').add({
        'name': session.name, // Example field
        'description': session.description, // Example field
        'imagePath': session.imagePath, // Automatically store the time
        'location': session.location,
        'sessionType': session.sessionType,
        'date': session.date
        // Add other fields from the session model as necessary
      });

      print('Session added successfully!');
    } catch (e) {
      print('Error adding session: $e');
    }
  }

  Future<List<SessionModel>> fetchSessions() async {
    try {
      final teamId = await TeamDatabase().getTeamId();
      final teamDocRef =
          FirebaseFirestore.instance.collection('Teams').doc(teamId);

      // Get the sessions subcollection for the team
      final querySnapshot = await teamDocRef.collection('sessions').get();

      // Convert the fetched documents to SessionModel objects
      return querySnapshot.docs.map((doc) {
        return SessionModel(
          id: doc.id,
          name: doc['name'],
          description: doc['description'],
          imagePath: doc['imagePath'],
          location: doc['location'],
          sessionType: doc['sessionType'],
          date: doc['date'], // Assuming the date is stored as a timestamp
        );
      }).toList();
    } catch (e) {
      log('Error fetching sessions: $e');
      return [];
    }
  }

  Future<void> deleteSession(SessionModel session) async {
    final teamId = await TeamDatabase().getTeamId();

    // Reference to the specific team's document
    final teamDocRef =
        FirebaseFirestore.instance.collection('Teams').doc(teamId);
    teamDocRef.collection('sessions').doc(session.id).delete();
    // Navigator.pop(context);
    AddSessionController().notifyListeners();
  }

  Future<void> updatedSession(SessionModel session) async {
    try {
      // Get the team ID from the TeamDatabase
      final teamId = await TeamDatabase().getTeamId();

      // Reference to the specific team's document
      final teamDocRef =
          FirebaseFirestore.instance.collection('Teams').doc(teamId);

      // Adding a new subcollection 'sessions' under the team document
      log('new name:${session.name}');
      log('new name:${session.date}');
      log('new name:${session.imagePath}');
      log('new name:${session.id}');
      await teamDocRef.collection('sessions').doc(session.id).update({
        'name': session.name, // Example field
        'description': session.description, // Example field
        'imagePath': session.imagePath, // Automatically store the time
        'location': session.location,
        'sessionType': session.sessionType,
        'date': session.date
        // Add other fields from the session model as necessary
      });

      print('Session Updated successfully!');
    } catch (e) {
      print('Error Updating session: $e');
    }
  }

Future<SessionModel?> getSession(String sessionId) async {
  try {
    final teamId = await TeamDatabase().getTeamId();
    final teamDocRef =
        FirebaseFirestore.instance.collection('Teams').doc(teamId);

    final sessionDoc = await teamDocRef.collection('sessions').doc(sessionId).get();

    if (sessionDoc.exists) {
      // Return the session as a SessionModel if the document exists
      return SessionModel(
        id: sessionDoc.id,
        name: sessionDoc['name'],
        description: sessionDoc['description'],
        imagePath: sessionDoc['imagePath'],
        location: sessionDoc['location'],
        sessionType: sessionDoc['sessionType'],
        date: sessionDoc['date'], // Assuming the date is stored as a timestamp
      );
    } else {
      // If the session does not exist, return null
      print('Session not found');
      return null;
    }
  } catch (e) {
    print('Error fetching session: $e');
    return null;
  }
}

}

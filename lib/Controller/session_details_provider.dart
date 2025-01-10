import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/sessions_database.dart';
import 'package:tactix_academy_manager/Model/Models/session_model.dart';

class SessionDetailsProvider extends ChangeNotifier {
  SessionModel? _session;
  bool _isLoading = false;

  SessionModel? get session => _session;
  bool get isLoading => _isLoading;

  // Fetch session data from the database
  Future<void> fetchSession(String sessionId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final fetchedSession = await SessionsDatabase().getSession(sessionId);
      _session = fetchedSession;
    } catch (error) {
      print("Error fetching session: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update session data
  Future<void> updateSession(SessionModel updatedSession) async {
    _isLoading = true;
    notifyListeners();
    try {
      await SessionsDatabase().updatedSession(updatedSession);

      _session = updatedSession; // Update local state with the new session
      log(_session.toString());
      notifyListeners();
    } catch (error) {
      print("Error updating session: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

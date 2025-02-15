// broadcast_provider.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/team_database.dart';

class BroadcastProvider extends ChangeNotifier {
  String? _teamId;
  bool _isLoading = true;
  final TextEditingController messageController = TextEditingController();
  final AnimationController animationController;

  BroadcastProvider({required this.animationController}) {
    fetchTeamId();
  }

  String? get teamId => _teamId;
  bool get isLoading => _isLoading;

  Future<void> fetchTeamId() async {
    try {
      String fetchedTeamId = await TeamDatabase().getTeamId();
      _teamId = fetchedTeamId;
      _isLoading = false;
      log('Team ID fetched successfully: $_teamId');
      notifyListeners();
    } catch (e) {
      log('Error fetching team ID: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  void sendMessage() async {
    String message = messageController.text.trim();
    if (message.isNotEmpty) {
      log('Sending message: $message');
      messageController.clear();
      await TeamDatabase().sendMessageBroadcast(message);
      notifyListeners();
    } else {
      log('Message is empty');
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
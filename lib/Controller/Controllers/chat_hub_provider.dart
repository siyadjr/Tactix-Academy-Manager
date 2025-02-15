import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/chat_hub_datebase.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/players_database.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/team_database.dart';
import 'package:tactix_academy_manager/Model/Models/chat_model.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';

class ChatHubProvider extends ChangeNotifier {
  List<PlayerModel> _chatPlayers = [];
  List<PlayerModel> _filteredPlayers = [];

  List<PlayerModel> get chatPlayers => _chatPlayers;
  List<PlayerModel> get filteredPlayers => _filteredPlayers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getChatPlayers() async {
    try {
      _isLoading = true;
      notifyListeners();
      _chatPlayers = await PlayerDatabase().getAllPlayers();
      _filteredPlayers = _chatPlayers;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createChatRoom(String playerId) async {
    await ChatHubDatabase().createChatRoom(playerId);
  }

  void filterPlayers(String query) {
    if (query.isEmpty) {
      _filteredPlayers = _chatPlayers;
    } else {
      _filteredPlayers = _chatPlayers
          .where((player) =>
              player.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Stream<List<ChatModel>> getMessages(String playerId) {
    return ChatHubDatabase().getMessages(playerId).map((snapshot) {
      return snapshot.map((messageData) {
        return ChatModel(
          message: messageData['message'],
          sender: messageData['sender'],
          time: (messageData['timeStamp'] as Timestamp?)?.toDate().toString() ??
              DateTime.now().toString(),
        );
      }).toList();
    });
  }

  Future<void> sendMessage(String message, String playerId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await ChatHubDatabase().sendMessage(message, userId, playerId);
    }
  }

  Stream<String> getLastMessage(String playerId) {
    return ChatHubDatabase().getLastMessage(playerId);
  }
}

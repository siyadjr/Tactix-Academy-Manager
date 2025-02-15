import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tactix_academy_manager/Controller/Controllers/chat_hub_provider.dart';
import 'package:tactix_academy_manager/Core/ReusableWidgets/loading_indicator.dart';
import 'package:tactix_academy_manager/Model/Models/chat_model.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';

class ChatScreenMainContent extends StatelessWidget {
  const ChatScreenMainContent({
    super.key,
    required this.chatProvider,
    required this.player,
    required this.currentUser,
    required this.opponentUser,
    required this.user,
  });

  final ChatHubProvider chatProvider;
  final PlayerModel player;
  final ChatUser currentUser;
  final ChatUser opponentUser;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: StreamBuilder<List<ChatModel>>(
        stream: chatProvider.getMessages(player.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingIndicator());
          }
    
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
    
          final messages = snapshot.data ?? [];
    
          return DashChat(
            currentUser: currentUser,
            messageOptions: MessageOptions(
              showTime: true,
              timeFormat: DateFormat('hh:mm a'),
              currentUserContainerColor: Colors.deepPurple[300],
              containerColor: Colors.grey.shade200,
              textColor: Colors.black,
              showOtherUsersAvatar: true,
              avatarBuilder: (user, size, onTap) {
                if (user.id == opponentUser.id) {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(player.userProfile),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            messages: messages.map((msg) {
              return ChatMessage(
                text: msg.message,
                user:
                    msg.sender == user?.uid ? currentUser : opponentUser,
                createdAt: DateTime.parse(msg.time),
              );
            }).toList(),
            onSend: (ChatMessage message) {
              chatProvider.sendMessage(message.text, player.id);
            },
            inputOptions: InputOptions(
              sendButtonBuilder: (onSend) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 4, right: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple[300]!,
                        Colors.deepPurple[500]!
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: onSend,
                  ),
                );
              },
              inputTextStyle: const TextStyle(color: Colors.black),
              inputDecoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 15),
              ),
            ),
          );
        },
      ),
    );
  }
}

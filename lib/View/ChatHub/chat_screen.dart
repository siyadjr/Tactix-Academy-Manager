import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/chat_hub_provider.dart';
import 'package:tactix_academy_manager/Core/ReusableWidgets/loading_indicator.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Model/Models/chat_model.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';
import 'package:tactix_academy_manager/View/ChatHub/Widgets/chat_screen_app_bar.dart';
import 'package:tactix_academy_manager/View/ChatHub/Widgets/chat_screen_main_content.dart';

class ChatScreen extends StatelessWidget {
  final PlayerModel player;
  const ChatScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatHubProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;

    final currentUser = ChatUser(
      id: user?.uid ?? "unknown",
      firstName: user?.displayName ?? "Me",
      profileImage: user?.photoURL,
    );

    final opponentUser = ChatUser(
      id: player.id,
      firstName: player.name,
      profileImage: player.userProfile,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ChatScreenAppBar(player: player),
          ChatScreenMainContent(chatProvider: chatProvider, player: player, currentUser: currentUser, opponentUser: opponentUser, user: user),
        ],
      ),
    );
  }
}


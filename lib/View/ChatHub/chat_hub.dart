import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/chat_hub_provider.dart';
import 'package:tactix_academy_manager/Core/ReusableWidgets/loading_indicator.dart';
import 'package:tactix_academy_manager/Core/Theme/custom_scaffold.dart';
import 'package:tactix_academy_manager/View/ChatHub/Widgets/chat_list_empty_state.dart';
import 'package:tactix_academy_manager/View/ChatHub/Widgets/chat_list_player_tiles.dart';
import 'package:tactix_academy_manager/View/ChatHub/Widgets/chat_list_search.dart';
import 'package:tactix_academy_manager/View/ChatHub/chat_screen.dart';

import '../../Core/Theme/app_colours.dart';

class ChatHub extends StatelessWidget {
  const ChatHub({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatHubProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getChatPlayers();
    });

    return CustomScaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: backGroundColor,
        title: const Text('Chat Hub', style: secondaryTextTheme),
      ),
      body: Column(
        children: [
          ChatListSearch(
            onChanged: provider.filterPlayers,
          ),
          Expanded(
            child: Consumer<ChatHubProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.isLoading) {
                  return const Center(child: LoadingIndicator());
                }

                if (chatProvider.filteredPlayers.isEmpty) {
                  return const EmptyState();
                }

                return ListView.separated(
                  itemCount: chatProvider.filteredPlayers.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey.shade200,
                    indent: 80,
                  ),
                  itemBuilder: (context, index) {
                    final player = chatProvider.filteredPlayers[index];

                    // Listen for the last message from the selected player
                    return StreamBuilder<String>(
                      stream: chatProvider
                          .getLastMessage(player.id), // Stream for last message
                      builder: (context, snapshot) {
                        String lastMessage = 'Tap to start a conversation';

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          lastMessage = 'Loading last message...';
                        }

                        if (snapshot.hasData) {
                          lastMessage = snapshot.data ?? 'No message available';
                        }

                        return PlayerTile(
                          player: player,
                          lastMessage: lastMessage,
                          onTap: () {
                            chatProvider.createChatRoom(player.id);
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        ChatScreen(player: player),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = const Offset(1.0, 0.0);
                                  var end = Offset.zero;
                                  var curve = Curves.easeInOutQuart;
                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .shimmer(duration: 1500.ms, delay: 300.ms);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

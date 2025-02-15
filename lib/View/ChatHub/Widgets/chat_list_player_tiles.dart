import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';

class PlayerTile extends StatelessWidget {
  final PlayerModel player;
  final String lastMessage;
  final Function() onTap;

  const PlayerTile({
    super.key,
    required this.player,
    required this.lastMessage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.blue.shade100,
            width: 2,
          ),
        ),
        child: CircleAvatar(
          backgroundImage: NetworkImage(player.userProfile),
          radius: 30,
        ),
      ),
      title: Text(
        player.name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: secondTextColour,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        lastMessage,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}

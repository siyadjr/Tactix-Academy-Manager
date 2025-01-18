import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';

Widget buildStatsSection(PlayerModel player) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          primaryColor.withOpacity(0.2),
          Colors.black.withOpacity(0.1),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildStatItem('Goals', player.goals.toString(), Icons.sports_soccer),
        buildDivider(),
        buildStatItem('Assists', player.assists.toString(), Icons.diversity_3),
        buildDivider(),
        buildStatItem('Matches', player.matches, Icons.sports),
      ],
    ),
  );
}

Widget buildInfoChip(IconData icon, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.6),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: primaryColor),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}

Widget buildStatItem(String label, String value, IconData icon) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon,
        color: primaryColor,
        size: 24,
      ),
      const SizedBox(height: 8),
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
        ),
      ),
    ],
  );
}

Widget buildDivider() {
  return Container(
    height: 40,
    width: 1,
    color: Colors.white.withOpacity(0.1),
  );
}

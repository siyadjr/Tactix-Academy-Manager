

import 'package:flutter/material.dart';

class TeamProfileStatCard extends StatelessWidget {
  const TeamProfileStatCard({
    super.key,
    required this.team,
  });

  final team;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.people, color: Colors.blue, size: 32),
          const SizedBox(width: 16),
          Text(
            '${team.teamPlayersCount} Players',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

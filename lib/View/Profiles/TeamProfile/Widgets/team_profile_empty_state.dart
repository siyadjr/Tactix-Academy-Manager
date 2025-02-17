

import 'package:flutter/material.dart';

class TeamProfileEmptyState extends StatelessWidget {
  const TeamProfileEmptyState({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sports_soccer, size: 64, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text(
            'No team data available',
            style: TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
        ],
      ),
    );
  }
}

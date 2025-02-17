import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TeamProfileCopyTeamId extends StatelessWidget {
  final String id;
  const TeamProfileCopyTeamId({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Team ID',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              SelectableText(
                id,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: id));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Team ID copied'),
                  backgroundColor: Colors.grey[900],
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(20),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(
              Icons.copy,
              color: Colors.blue,
              size: 20,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.withOpacity(0.1),
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }
}

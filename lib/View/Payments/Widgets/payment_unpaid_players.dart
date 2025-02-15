import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';

class PaymentUnpaidPlayers extends StatelessWidget {
  final List<PlayerModel> unpaidPlayers;

  const PaymentUnpaidPlayers({super.key, required this.unpaidPlayers});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: unpaidPlayers.map((player) {
        return Card(
          color: backGroundColor,
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  backgroundImage: player.userProfile.isNotEmpty
                      ? NetworkImage(player.userProfile)
                      : null,
                  child: player.userProfile.isEmpty
                      ? const Icon(Icons.person, color: Colors.blueGrey)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Payment Pending",
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.warning_rounded,
                  color: Colors.orange.shade400,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

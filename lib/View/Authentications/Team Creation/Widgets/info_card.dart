import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF14082E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: mainTextColour.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAD3CD0).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: mainTextColour.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.info_outline,
              color: mainTextColour,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "After creating a team, you'll receive a unique Team ID. Share this ID with your players to join your Elite Squad.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

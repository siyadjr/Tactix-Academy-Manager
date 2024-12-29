import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

class TeamCreateWelcome extends StatelessWidget {
  const TeamCreateWelcome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome  User",
          style: TextStyle(
            color: mainTextColour,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Let's Create Your ELITE SQUAD",
          style: TextStyle(
            color: mainTextColour2,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
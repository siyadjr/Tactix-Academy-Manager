import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text(
        'No players found',
        style: TextStyle(
          color: secondTextColour,
          fontSize: 12,
        ),
      ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
    );
  }
}

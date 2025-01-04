import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

void showTeamIdDialog({
  required BuildContext context,
  required String teamId,
  required VoidCallback onNavigate,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        "Team Created",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Your Team ID is:",
            style: TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 10),
          SelectableText(
            teamId,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            "You can copy the Team ID or proceed to the Home screen.",
            style: TextStyle(fontSize: 14, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: teamId));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Team ID copied to clipboard!")),
            );
          },
          child: const Text("Copy"),
        ),
        ElevatedButton(
          onPressed: onNavigate,
          style: ElevatedButton.styleFrom(
            backgroundColor: mainTextColour,
          ),
          child: const Text(
            "Enter",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

class CustomDialog {
  static void showCustomDialog({
    required BuildContext context,
    required String title,
    required String content,
    required List<Widget> actions,
    String? imageUrl, // Optional, if you want to keep the image
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Customize to match your theme
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Column(
            children: [
              if (imageUrl != null) // Check if imageUrl is provided
                Image.asset(
                  imageUrl,
                  height: 100,
                  fit: BoxFit.fitHeight,
                ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: mainTextColour,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: mainTextColour,
              fontSize: 16,
            ),
          ),
          actions: actions,
        );
      },
    );
  }
}

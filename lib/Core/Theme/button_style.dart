 import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: mainTextColour, // Background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0), // Button padding
    );
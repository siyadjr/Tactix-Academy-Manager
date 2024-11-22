import 'package:flutter/material.dart';

import '../../../Core/Theme/app_colours.dart';

class LicenceHeaderFiles extends StatelessWidget {
  const LicenceHeaderFiles({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Welcome Coach",
          style: TextStyle(
            fontSize: 24,
            color: mainTextColour,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Please upload your professional coaching license for evaluation.",
          style: TextStyle(
            fontSize: 16,
            color: secondTextColour.withOpacity(0.7),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}



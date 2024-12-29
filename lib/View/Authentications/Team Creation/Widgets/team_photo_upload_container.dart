import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

class TeamPhotoUploadContainer extends StatelessWidget {
  const TeamPhotoUploadContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo, color: mainTextColour, size: 32),
        SizedBox(height: 8),
        Text(
          "Upload Logo",
          style: TextStyle(color: mainTextColour, fontSize: 12),
        ),
      ],
    );
  }
}

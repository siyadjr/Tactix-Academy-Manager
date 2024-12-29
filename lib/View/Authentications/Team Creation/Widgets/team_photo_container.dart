import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

class TeamPhotoContainer extends StatelessWidget {
  const TeamPhotoContainer({
    super.key,
    required this.child,
    required this.onTap,
  });

  final Widget? child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: mainTextColour, width: 2),
          boxShadow: [
            BoxShadow(
              color: mainTextColour.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

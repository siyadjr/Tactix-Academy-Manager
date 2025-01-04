import 'package:flutter/material.dart';

class MainFeaturesHomeScreen extends StatelessWidget {
  final String text;
  final MaterialColor color;
  final String imagePath;
  final Widget nextPage;
  const MainFeaturesHomeScreen(
      {super.key,
      required this.text,
      required this.color,
      required this.imagePath,
      required this.nextPage});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => nextPage));
      },
      child: Container(
        height: 140,
        width: screenWidth / 3.5,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12), // Clip gradient and image
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              // Gradient Overlay (at the bottom)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8), // Dark at the bottom
                        Colors.transparent, // Gradually transparent
                      ],
                    ),
                  ),
                ),
              ),
              // Centered Text
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

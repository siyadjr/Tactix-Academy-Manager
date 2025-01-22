import 'package:flutter/material.dart';

import 'package:flutter_animator/flutter_animator.dart';
import 'package:lottie/lottie.dart';

class LoadingIndicator extends StatelessWidget {
  final Color textColor;
  final double size;
  final String loadingText;
  final String lottieAsset;

  const LoadingIndicator({
    super.key,
    this.textColor = Colors.white,
    this.size = 150,
    this.loadingText = 'Loading...',
    this.lottieAsset = 'Assets/Lottie loader animation.json',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeInDown(
        preferences: const AnimationPreferences(
          duration: Duration(milliseconds: 800),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Lottie animation with size adjustments
              Lottie.asset(
                lottieAsset,
                height: size,
                width: size,
                repeat: true,
                frameRate: FrameRate.max,
              ),
              // Pulse and scale effect on the text
            ],
          ),
        ]),
      ),
    );
  }
}

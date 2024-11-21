import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Authentications/Onboarding/get_started1.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => const GetStarted()));
    });
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Center(
        child: Image.asset(
          'Assets/Tactix app manager logo copy.jpg',
          scale: 5,
        ),
      ),
    );
  }
}

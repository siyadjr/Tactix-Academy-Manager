import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Core/important_data.dart';
import 'package:tactix_academy_manager/View/Authentications/Onboarding/get_started1.dart';
import 'package:tactix_academy_manager/View/Authentications/Team%20Creation/team_create.dart';
import 'package:tactix_academy_manager/View/Authentications/lisence_request.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4), () {
      // checkRegister(context);
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

  Future<void> checkRegister(BuildContext context) async {
    final sharedpref = await SharedPreferences.getInstance();
    final value = sharedpref.getBool(userRegisterd);
    if (value == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => const TeamCreate()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => const GetStarted()));
    }
  }
}

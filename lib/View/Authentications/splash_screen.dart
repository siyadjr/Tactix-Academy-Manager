import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Core/important_data.dart';
import 'package:tactix_academy_manager/Model/Firebase/Authentication%20funcations/user.db.dart';
import 'package:tactix_academy_manager/View/Authentications/Onboarding/get_started1.dart';
import 'package:tactix_academy_manager/View/Authentications/lisence_request.dart';
import 'package:tactix_academy_manager/View/HomeScreen/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4), () {
      checkRegister(context);
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (ctx) => const GetStarted()));
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
    final register = sharedpref.getBool(userRegisterd);
    final teamCreated = sharedpref.getBool(userAuthCompleated);
    final logined = sharedpref.getBool(userLoggedIn);

    if (register == true) {
      if (teamCreated != true) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (ctx) => const CoachingLicenseScreen()));
      } else if (logined == false) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => const GetStarted()));
      } else {
        UserDatbase().fetchUserData();

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => const HomeScreen()));
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => const GetStarted()));
    }
  }
}

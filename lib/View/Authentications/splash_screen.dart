import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Core/important_data.dart';
import 'package:tactix_academy_manager/Model/Firebase/Authentication%20funcations/user.db.dart';
import 'package:tactix_academy_manager/View/Authentications/Onboarding/get_started1.dart';
import 'package:tactix_academy_manager/View/Authentications/lisence_request.dart';
import 'package:tactix_academy_manager/View/HomeScreen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await requestNotificationPermission();
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        checkRegister(context);
      }
    });
  }

  Future<void> requestNotificationPermission() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      log('User granted permission: ${settings.authorizationStatus}');
    } catch (e) {
      log('Error requesting notification permission: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
        UserDatbase().updateFcmToken();

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => const HomeScreen()));
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => const GetStarted()));
    }
  }
}

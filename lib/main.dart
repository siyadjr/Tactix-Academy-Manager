import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Api/gemini_ai.dart';
import 'package:tactix_academy_manager/Controller/Controllers/add_session_controller.dart';
import 'package:tactix_academy_manager/Controller/Controllers/attendence_provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/home_screen_provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/license_provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/license_request_controller.dart';
import 'package:tactix_academy_manager/Controller/Controllers/player_attendance_details_provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/player_details_controller.dart';
import 'package:tactix_academy_manager/Controller/Controllers/team_creation_provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/session_details_provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/todays_attendance_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Authentications/splash_screen.dart';
import 'package:tactix_academy_manager/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: GEMINI_API_KEY);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LicenseProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TeamCreationProvider(),
        ),
        ChangeNotifierProvider(create: (_) => TeamProvider()),
        ChangeNotifierProvider(create: (_) => AddSessionController()),
        ChangeNotifierProvider(create: (_) => LicenseRequestController()),
        ChangeNotifierProvider(create: (_) => SessionDetailsProvider()),
        ChangeNotifierProvider(create: (_) => PlayerDetailsController()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => TodaysAttendanceProvider()),
        ChangeNotifierProvider(create: (_) => PlayerAttendanceDetailsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themdata,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

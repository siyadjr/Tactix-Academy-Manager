import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/add_session_controller.dart';
import 'package:tactix_academy_manager/Controller/home_screen_provider.dart';
import 'package:tactix_academy_manager/Controller/license_provider.dart';
import 'package:tactix_academy_manager/Controller/license_request_controller.dart';
import 'package:tactix_academy_manager/Controller/team_creation_provider.dart';
import 'package:tactix_academy_manager/Controller/session_details_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Authentications/splash_screen.dart';
import 'package:tactix_academy_manager/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        ChangeNotifierProvider(create: (_)=>SessionDetailsProvider())
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:tactix_academy_manager/Controller/Controllers/home_screen_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/custom_scaffold.dart';
import 'package:tactix_academy_manager/View/Attendence/Screens/attendence.dart';
import 'package:tactix_academy_manager/View/BroadCast/broad_cast.dart';
import 'package:tactix_academy_manager/View/HomeScreen/Screens/join_requests.dart';
import 'package:tactix_academy_manager/View/HomeScreen/Widgets/chat_hub_container.dart';
import 'package:tactix_academy_manager/View/HomeScreen/Widgets/main_features.dart';
import 'package:tactix_academy_manager/View/HomeScreen/Widgets/secondary_features.dart';
import 'package:tactix_academy_manager/View/HomeScreen/Widgets/team_basic_details.dart';
import 'package:tactix_academy_manager/View/Payments/payments.dart';
import 'package:tactix_academy_manager/View/Sessions/all_sessions.dart';
import 'package:tactix_academy_manager/View/Tactix-AI/tactix_ai_screen.dart';

import '../Players/all_players.dart';
// ... rest of your imports

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TeamProvider>(context, listen: false).fetchTeamNameAndPhoto();
    });

    return CustomScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            // Fade in the header
            FadeIn(
              preferences: const AnimationPreferences(
                duration: Duration(milliseconds: 800),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Manage Your",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        Consumer<TeamProvider>(
                          builder: (context, teamProvider, child) {
                            return Text(
                              teamProvider.teamName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => const JoinRequests(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.notification_important_rounded,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),

            SlideInLeft(
              preferences: const AnimationPreferences(
                duration: Duration(milliseconds: 1000),
                offset: Duration(milliseconds: 200),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MainFeaturesHomeScreen(
                      text: 'Sessions',
                      color: Colors.blue,
                      imagePath: 'Assets/Sessions.png',
                      nextPage: AllSessions(),
                    ),
                    MainFeaturesHomeScreen(
                      text: 'BroadCast',
                      color: Colors.yellow,
                      imagePath: 'Assets/BroadCast.png',
                      nextPage: BroadCast(),
                    ),
                    MainFeaturesHomeScreen(
                      text: 'Players',
                      color: Colors.green,
                      imagePath: 'Assets/Players.png',
                      nextPage: AllPlayers(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Bounce in the secondary features
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SecondaryFeatureHomeScreen(
                  nextPage: const Payments(),
                  color1: Colors.green,
                  icon: const Icon(
                    Icons.payment,
                    color: Colors.white,
                  ),
                  text: 'Payments',
                ),
                SecondaryFeatureHomeScreen(
                  nextPage: const Attendance(),
                  color1: Colors.blue,
                  icon: const Icon(
                    Icons.bookmark,
                    color: Colors.white,
                  ),
                  text: 'Attendence',
                ),
                SecondaryFeatureHomeScreen(
                  nextPage: const TactixAiScreen(),
                  color1: Colors.purple,
                  image: 'Assets/tactix-bot-animation.gif',
                  icon: const Icon(
                    Icons.smart_toy,
                    color: Colors.white,
                  ),
                  text: 'Tactix-AI',
                )
              ],
            ),
            const SizedBox(height: 20),

            FadeInUp(
              preferences: const AnimationPreferences(
                duration: Duration(milliseconds: 1000),
                offset: Duration(milliseconds: 600),
              ),
              child: const ChatHubContainer(),
            ),
            FadeIn(
              preferences: const AnimationPreferences(
                duration: Duration(milliseconds: 1000),
                offset: Duration(milliseconds: 800),
              ),
              child: const TeamBasicDetails(),
            ),
          ],
        ),
      ),
    );
  }
}

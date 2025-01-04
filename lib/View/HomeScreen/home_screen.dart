import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/home_screen_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/custom_scaffold.dart';
import 'package:tactix_academy_manager/View/BroadCast/broad_cast.dart';
import 'package:tactix_academy_manager/View/HomeScreen/Screens/join_requests.dart';
import 'package:tactix_academy_manager/View/HomeScreen/Widgets/chat_hub_container.dart';
import 'package:tactix_academy_manager/View/HomeScreen/Widgets/main_features.dart';
import 'package:tactix_academy_manager/View/HomeScreen/Widgets/secondary_features.dart';
import 'package:tactix_academy_manager/View/HomeScreen/Widgets/team_basic_details.dart';
import 'package:tactix_academy_manager/View/Players/all_players.dart';
import 'package:tactix_academy_manager/View/Sessions/all_sessions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final userData = FirebaseAuth.instance.currentUser;

    // Fetch team name when the screen builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TeamProvider>(context, listen: false).fetchTeamNameAndPhoto();
    });

    return CustomScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Padding(
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
                          onPressed: () {},
                          icon: const Icon(
                            Icons.format_list_numbered_sharp,
                            color: Colors.green,
                          )),
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
            const SizedBox(height: 50),
            const Padding(
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SecondaryFeatureHomeScreen(
                  color1: Colors.green,
                  icon: const Icon(
                    Icons.payment,
                    color: Colors.white,
                  ),
                  text: 'Payments',
                ),
                SecondaryFeatureHomeScreen(
                  color1: Colors.blue,
                  icon: const Icon(
                    Icons.bookmark,
                    color: Colors.white,
                  ),
                  text: 'Attendence',
                ),
                SecondaryFeatureHomeScreen(
                  color1: Colors.purple,
                  icon: const Icon(
                    Icons.newspaper,
                    color: Colors.white,
                  ),
                  text: 'News',
                )
              ],
            ),
            const SizedBox(height: 20),
            const ChatHubContainer(),
            const TeamBasicDetails(),
          ],
        ),
      ),
    );
  }
}

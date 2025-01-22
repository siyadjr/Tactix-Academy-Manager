import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';
import 'package:tactix_academy_manager/View/Attendence/Screens/player_attendance_details.dart';
import 'package:tactix_academy_manager/View/Attendence/Widgets/attendance_statistics_widgets.dart';

class AttendanceStatsticsCard extends StatelessWidget {
  const AttendanceStatsticsCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.players,
    required this.size,
    required this.isPortrait,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final List<PlayerModel> players;
  final Size size;
  final bool isPortrait;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: mainTextColour.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: mainTextColour.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(size.width * 0.03),
            decoration: BoxDecoration(
              color: mainTextColour.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: size.width * 0.05),
                SizedBox(width: size.width * 0.02),
                Text(
                  title,
                  style: TextStyle(
                    color: secondTextColour,
                    fontSize: size.width * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: players.isEmpty
                ? buildEmptyState('No ${title.toLowerCase()}', size)
                : ListView.builder(
                    padding: EdgeInsets.all(size.width * 0.02),
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final player = players[index];
                      return Card(
                        color: mainTextColour.withOpacity(0.05),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    PlayerAttendanceDetails(player: player),
                              ),
                            );
                          },
                          contentPadding: EdgeInsets.all(size.width * 0.02),
                          leading: CircleAvatar(
                            radius: size.width * 0.05,
                            backgroundColor: mainTextColour.withOpacity(0.2),
                            backgroundImage: player.userProfile.isNotEmpty
                                ? NetworkImage(player.userProfile)
                                : null,
                            child: player.userProfile.isEmpty
                                ? Icon(Icons.person, size: size.width * 0.05)
                                : null,
                          ),
                          title: Text(
                            player.name,
                            style: TextStyle(
                              color: secondTextColour,
                              fontSize: size.width * 0.035,
                            ),
                          ),
                          subtitle: Text(
                            'Position: ${player.position}',
                            style: TextStyle(
                              color: secondTextColour.withOpacity(0.7),
                              fontSize: size.width * 0.03,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

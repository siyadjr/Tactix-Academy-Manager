import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Controller/Controllers/todays_attendance_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Attendence/Screens/attendance_overall_statistics.dart';
import 'package:tactix_academy_manager/View/Attendence/Screens/player_attendance_details.dart';

Widget buildAllPlayersList(TodaysAttendanceProvider provider, Size size) {
  return Expanded(
    child: Container(
      decoration: BoxDecoration(
        color: mainTextColour.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: mainTextColour.withOpacity(0.1), width: 1),
      ),
      child: provider.allPlayers.isEmpty
          ? buildEmptyState('No players available', size)
          : ListView.separated(
              padding: EdgeInsets.all(size.width * 0.02),
              itemCount: provider.allPlayers.length,
              separatorBuilder: (context, index) =>
                  Divider(color: mainTextColour.withOpacity(0.1)),
              itemBuilder: (context, index) {
                final player = provider.allPlayers[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) =>
                            PlayerAttendanceDetails(player: player),
                      ),
                    );
                  },
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: size.width * 0.02,
                  ),
                  leading: CircleAvatar(
                    radius: size.width * 0.06,
                    backgroundColor: mainTextColour.withOpacity(0.2),
                    backgroundImage: player.userProfile.isNotEmpty
                        ? NetworkImage(player.userProfile)
                        : null,
                    child: player.userProfile.isEmpty
                        ? Icon(Icons.person, size: size.width * 0.06)
                        : null,
                  ),
                  title: Text(
                    player.name,
                    style: TextStyle(
                      color: secondTextColour,
                      fontSize: size.width * 0.04,
                    ),
                  ),
                  subtitle: Text(
                    'Position: ${player.position}',
                    style: TextStyle(
                      color: secondTextColour.withOpacity(0.7),
                      fontSize: size.width * 0.035,
                    ),
                  ),
                );
              },
            ),
    ),
  );
}

Widget buildEmptyState(String message, Size size) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.warning_amber_rounded,
          size: size.width * 0.1,
          color: mainTextColour.withOpacity(0.5),
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          message,
          style: TextStyle(
            color: secondTextColour.withOpacity(0.7),
            fontSize: size.width * 0.035,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget buildOverallStatisticsButton(BuildContext context, Size size) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.only(top: size.height * 0.02),
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (ctx) => AttendanceOverallStatistics()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: mainTextColour,
        foregroundColor: secondTextColour,
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics, size: size.width * 0.06),
          SizedBox(width: size.width * 0.03),
          Text(
            'View Overall Statistics',
            style: TextStyle(
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

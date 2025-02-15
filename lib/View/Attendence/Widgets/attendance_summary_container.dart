import 'package:flutter/material.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_left.dart';
import 'package:tactix_academy_manager/Controller/Controllers/attendence_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';
import 'package:tactix_academy_manager/View/Attendence/Screens/player_attendance_details.dart';

Widget buildSummaryCard(AttendanceProvider provider, Size size) {
  return FadeInLeft(
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: mainTextColour.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: mainTextColour.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attendance Summary',
            style: TextStyle(
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
              color: secondTextColour,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSummaryItem(
                  'Total Players',
                  provider.attendedPlayers.length +
                      provider.absentPlayers.length,
                  Icons.people,
                  size),
              buildSummaryItem('Attended', provider.attendedPlayers.length,
                  Icons.check_circle, size),
              buildSummaryItem(
                  'Absent', provider.absentPlayers.length, Icons.cancel, size),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget buildSummaryItem(String label, int value, IconData icon, Size size) {
  return Column(
    children: [
      Icon(icon, color: mainTextColour, size: size.width * 0.06),
      SizedBox(height: size.height * 0.005),
      Text(
        value.toString(),
        style: TextStyle(
          fontSize: size.width * 0.045,
          fontWeight: FontWeight.bold,
          color: secondTextColour,
        ),
      ),
      Text(
        label,
        style: TextStyle(
          fontSize: size.width * 0.035,
          color: secondTextColour.withOpacity(0.7),
        ),
      ),
    ],
  );
}

Widget buildPlayerSection(
    String title, IconData icon, List<PlayerModel> players, Size size) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildSectionTitle(title, icon, size),
      SizedBox(height: size.height * 0.01),
      players.isEmpty
          ? buildEmptyState('No $title', size)
          : buildPlayerList(players, size),
    ],
  );
}

Widget buildSectionTitle(String title, IconData icon, Size size) {
  return FadeInLeft(
    child: Container(
      padding: EdgeInsets.symmetric(
          vertical: size.height * 0.015, horizontal: size.width * 0.04),
      decoration: BoxDecoration(
        color: mainTextColour.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: mainTextColour, size: size.width * 0.06),
          SizedBox(width: size.width * 0.03),
          Text(
            title,
            style: TextStyle(
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.bold,
              color: secondTextColour,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildPlayerList(List<PlayerModel> players, Size size) {
  return Container(
    decoration: BoxDecoration(
      color: mainTextColour.withOpacity(0.05),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: mainTextColour.withOpacity(0.1), width: 1),
    ),
    child: ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(size.width * 0.02),
      itemCount: players.length,
      separatorBuilder: (context, index) =>
          Divider(color: mainTextColour.withOpacity(0.1)),
      itemBuilder: (context, index) {
        final player = players[index];
        return ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => PlayerAttendanceDetails(player: player)));
            ;
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

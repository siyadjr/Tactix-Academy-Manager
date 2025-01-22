import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/todays_attendance_provider.dart';
import 'package:tactix_academy_manager/Core/ReusableWidgets/loading_indicator.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';
import 'package:tactix_academy_manager/View/Attendence/Screens/player_attendance_details.dart';
import 'package:tactix_academy_manager/View/Attendence/Widgets/attendance_statistics_card.dart';
import 'package:tactix_academy_manager/View/Attendence/Widgets/attendance_statistics_widgets.dart';
import '../../../Core/Theme/app_colours.dart';

class AttendanceStatistics extends StatelessWidget {
  const AttendanceStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    final todayAttendanceprovider =
        Provider.of<TodaysAttendanceProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      todayAttendanceprovider.fetchAllStatistics();
    });

    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Attendance Analysis', style: secondaryTextTheme),
      ),
      body: Consumer<TodaysAttendanceProvider>(
        builder: (context, provider, child) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                backGroundColor,
                backGroundColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.04),
            child: provider.stasticsIsloading
                ? const LoadingIndicator()
                : Column(
                    children: [
                      buildSectionTitle('Today\'s Attendance', Icons.today, size),
                      buildTodayAttendanceRow(provider, size, isPortrait),
                      SizedBox(height: size.height * 0.02),
                      buildSectionTitle(
                          'All Players Analysis', Icons.people, size),
                      buildAllPlayersList(provider, size),
                      buildOverallStatisticsButton(context, size),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title, IconData icon, Size size) {
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.02),
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
    );
  }

  Widget buildTodayAttendanceRow(
      TodaysAttendanceProvider provider, Size size, bool isPortrait) {
    if (provider.todayAttendedPlayers.isEmpty &&
        provider.todaysAbsentPlayers.isEmpty) {
      return buildEmptyState('No attendance recorded for today!', size);
    }

    return SizedBox(
      height: isPortrait ? size.height * 0.35 : size.height * 0.5,
      child: Row(
        children: [
          Expanded(
            child: AttendanceStatsticsCard(title: 'Attended Players', icon: Icons.check_circle, iconColor: Colors.green.withOpacity(0.7), players: provider.todayAttendedPlayers, size: size, isPortrait: isPortrait),
          ),
          SizedBox(width: size.width * 0.04),
          Expanded(
            child: AttendanceStatsticsCard(title: 'Absent Players', icon: Icons.cancel, iconColor: Colors.red.withOpacity(0.7), players: provider.todaysAbsentPlayers, size: size, isPortrait: isPortrait),
          ),
        ],
      ),
    );
  }

  
}



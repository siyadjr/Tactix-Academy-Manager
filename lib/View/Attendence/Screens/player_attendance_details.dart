import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/player_attendance_details_provider.dart';
import 'package:tactix_academy_manager/Core/ReusableWidgets/loading_indicator.dart';
import 'package:tactix_academy_manager/Core/Theme/custom_scaffold.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';
import 'package:tactix_academy_manager/View/Attendence/Widgets/attendance_date_section.dart';
import 'package:tactix_academy_manager/View/Attendence/Widgets/attendance_empty_view.dart';
import 'package:tactix_academy_manager/View/Attendence/Widgets/attendance_stats_card.dart';

class PlayerAttendanceDetails extends StatelessWidget {
  final PlayerModel player;
  const PlayerAttendanceDetails({super.key,required this.player});

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<PlayerAttendanceDetailsProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchAllAttendance(player.id);
    });

    return CustomScaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Attendance Records',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Consumer<PlayerAttendanceDetailsProvider>(
        builder: (context, attendanceProvider, child) {
          if (attendanceProvider.isLoading) {
            return const LoadingIndicator();
          }

          if (attendanceProvider.attendedDates.isEmpty &&
              attendanceProvider.absentDates.isEmpty) {
            return const EmptyAttendanceView();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                AttendanceStatsCard(
                  attended: attendanceProvider.attendedDates.length,
                  absent: attendanceProvider.absentDates.length,
                ),
                const SizedBox(height: 24),
                AttendanceDateSection(
                  title: "Present",
                  dates: attendanceProvider.attendedDates,
                  iconData: Icons.check_circle,
                  iconColor: Colors.green,
                ),
                const SizedBox(height: 24),
                AttendanceDateSection(
                  title: "Absent",
                  dates: attendanceProvider.absentDates,
                  iconData: Icons.cancel,
                  iconColor: Colors.red,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

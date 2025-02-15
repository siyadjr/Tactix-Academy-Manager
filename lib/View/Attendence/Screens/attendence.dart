import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tactix_academy_manager/Controller/Controllers/attendence_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Core/Theme/custom_scaffold.dart';
import 'package:tactix_academy_manager/View/Attendence/Screens/all_attendance.dart';
import 'package:tactix_academy_manager/View/Attendence/Widgets/attendance_add_bottom_sheet.dart';
import 'package:tactix_academy_manager/View/Attendence/Widgets/attendance_tracker_container.dart';

class Attendance extends StatelessWidget {
  const Attendance({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchAttendance();
    });

    return CustomScaffold(
      appBar: AppBar(
        title: const Text('Attendance Management', style: secondaryTextTheme)
            .animate()
            .fadeIn(duration: 600.ms)
            .slideX(begin: -30, end: 0),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AttendanceTrackerContainer(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Attendance',
                  style: secondaryTextTheme.copyWith(fontSize: 16),
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -20, end: 0),
              ],
            ),
            const SizedBox(height: 16),
            const AllAttendanceList(),
          ],
        ),
      ),
      button: (p0) {
        showAttendanceBottomSheet(context);
      },
    );
  }
}

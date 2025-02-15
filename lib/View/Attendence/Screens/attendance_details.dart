import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/attendence_provider.dart';
import 'package:tactix_academy_manager/Core/ReusableWidgets/loading_indicator.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Model/Models/attendance_model.dart';
import 'package:tactix_academy_manager/View/Attendence/Widgets/attendance_summary_container.dart';

class AttendanceDetails extends StatelessWidget {
  final AttendanceModel attendance;
  const AttendanceDetails({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    final attendanceProvider =
        Provider.of<AttendanceProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      attendanceProvider.fetchAttendedPlayers(attendance.attendedPlayers);
    });

    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Attendance Details', style: secondaryTextTheme),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: backGroundColor),
            onPressed: () =>
                _showDeleteConfirmationDialog(context, attendanceProvider),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer<AttendanceProvider>(
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
              child: provider.isPlayerFetching
                  ? const LoadingIndicator()
                  : buildAttendanceContent(provider, size),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, AttendanceProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Attendance',
              style: TextStyle(
                  color: secondTextColour, fontWeight: FontWeight.bold)),
          content: Text(
            'Are you sure you want to delete this attendance record?',
            style: TextStyle(color: secondTextColour.withOpacity(0.8)),
          ),
          backgroundColor: backGroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: [
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(color: secondTextColour)),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child:
                  const Text('Delete', style: TextStyle(color: Colors.white)),
              onPressed: () {
                // Implement delete attendance logic here
                provider.deleteAttendance(attendance.id);
                Navigator.of(dialogContext).pop();
                context.read<AttendanceProvider>().fetchAttendance();
                Navigator.of(context).pop(); // Go back to previous screen
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildAttendanceContent(AttendanceProvider provider, Size size) {
    return FadeIn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSummaryCard(provider, size),
          SizedBox(height: size.height * 0.02),
          buildPlayerSection('Attended Players', Icons.check_circle,
              provider.attendedPlayers, size),
          SizedBox(height: size.height * 0.02),
          buildPlayerSection(
              'Absent Players', Icons.cancel, provider.absentPlayers, size),
        ],
      ),
    );
  }
}

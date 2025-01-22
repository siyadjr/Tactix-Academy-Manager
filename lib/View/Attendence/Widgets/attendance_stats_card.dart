import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Attendence/Widgets/attendance_stat_item.dart';

class AttendanceStatsCard extends StatelessWidget {
  final int attended;
  final int absent;

  const AttendanceStatsCard({
    super.key,
    required this.attended,
    required this.absent,
  });

  @override
  Widget build(BuildContext context) {
    final total = attended + absent;
    final attendancePercentage = total > 0 ? (attended / total * 100) : 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatItem(
                  label: 'Present',
                  value: attended,
                  color: Colors.green,
                ),
                StatItem(
                  label: 'Absent',
                  value: absent,
                  color: Colors.red,
                ),
                StatItem(
                  label: 'Total',
                  value: total,
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: attendancePercentage / 100,
                backgroundColor: Colors.grey[200],
                color: Colors.green,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${attendancePercentage.toStringAsFixed(1)}% Attendance',
              style: const TextStyle(
                color: mainTextColour,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

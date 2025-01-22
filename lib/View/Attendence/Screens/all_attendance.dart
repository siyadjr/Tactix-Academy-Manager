import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/attendence_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

class AllAttendanceList extends StatelessWidget {
  const AllAttendanceList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<AttendanceProvider>(
        builder: (context, provider, child) {
          if (provider.attendanceList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy,
                          size: 64,
                          color: mainTextColour.withOpacity(0.5))
                      .animate()
                      .scale(duration: 400.ms),
                  const SizedBox(height: 16),
                  Text(
                    'No attendance assigned for today',
                    style: TextStyle(
                      color: secondTextColour.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: provider.attendanceList.length,
            itemBuilder: (context, index) {
              final attendance = provider.attendanceList[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 8,
                color: backGroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: mainTextColour.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: mainTextColour.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.event_available,
                      color: mainTextColour,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    'Date: ${attendance['date']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: secondTextColour,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: secondTextColour.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Time: ${attendance['time']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: secondTextColour.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: mainTextColour,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: (50 * index).ms)
                  .slideX(begin: 30, end: 0);
            },
          );
        },
      ),
    );
  }
}

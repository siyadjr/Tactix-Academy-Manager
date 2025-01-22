import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/todays_attendance_provider.dart';
import 'package:tactix_academy_manager/Core/ReusableWidgets/loading_indicator.dart';
import 'package:tactix_academy_manager/View/Attendence/Screens/attendance_statistics.dart';

class AttendanceTrackerContainer extends StatelessWidget {
  const AttendanceTrackerContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<TodaysAttendanceProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchTodaysAttendance();
    });
    return SizedBox(
      child: Consumer<TodaysAttendanceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingIndicator();
          }

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withBlue(150),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -30,
                  top: -30,
                  child: Icon(
                    Icons.sports_soccer,
                    size: 140,
                    color: Colors.white.withOpacity(0.1),
                  ).animate().fade(duration: 600.ms).scale(delay: 200.ms),
                ),
                Positioned(
                  left: -20,
                  bottom: -20,
                  child: Icon(
                    Icons.stadium_outlined,
                    size: 100,
                    color: Colors.white.withOpacity(0.1),
                  ).animate().fade(duration: 600.ms).scale(delay: 400.ms),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.people_outline,
                                  color: Colors.white, size: 32)
                              .animate()
                              .fade(duration: 400.ms)
                              .slideX(begin: -10, end: 0),
                          const SizedBox(width: 12),
                          const Text(
                            'Attendance Tracker',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              .animate()
                              .fade(duration: 400.ms)
                              .slideX(begin: -10, end: 0),
                        ],
                      ),
                      const SizedBox(height: 16),
                      provider.attendedPlayers.isNotEmpty
                          ? Text(
                              'Attended players today: ${provider.attendedPlayers.length}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            )
                          : const Text(
                              'No attendance recorded for today!',
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 16),
                            ),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => const AttendanceStatistics()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 16),
                            elevation: 4,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.analytics_outlined,
                                size: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'View Details',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fade(duration: 400.ms)
                            .slideY(begin: 10, end: 0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/attendance_overall_provider.dart';
import 'package:tactix_academy_manager/Core/ReusableWidgets/loading_indicator.dart';
import 'package:tactix_academy_manager/Core/Theme/custom_scaffold.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';
import '../../../Core/Theme/app_colours.dart';

class AttendanceOverallStatistics extends StatelessWidget {
  const AttendanceOverallStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final provider =
        Provider.of<AttendanceOverallProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchOverallAttendanceStatistics();
    });

    return CustomScaffold(
      body: Consumer<AttendanceOverallProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: LoadingIndicator());
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: screenHeight * 0.2,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Attendance Insights',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [backGroundColor, blackColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildStatisticsCard(
                      context: context,
                      title: 'Overall Attendance Statistics',
                      content: [
                        'Total Players: ${provider.totalPlayers}',
                        'Total Attendance Sessions: ${provider.totalAttendanceSessions}',
                        'Overall Attendance Rate: ${provider.overallAttendanceRate.toStringAsFixed(2)}%',
                      ],
                      icon: Icons.analytics_outlined,
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideX(begin: 0.1, end: 0),
                    SizedBox(height: screenHeight * 0.02),
                    _buildAttendanceRankCard(
                      context: context,
                      title: 'Most Attended Players',
                      provider: provider,
                      mostAttended: true,
                    )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 300.ms)
                        .slideX(begin: 0.1, end: 0),
                    SizedBox(height: screenHeight * 0.02),
                    _buildAttendanceRankCard(
                      context: context,
                      title: 'Least Attended Players',
                      provider: provider,
                      mostAttended: false,
                    )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 600.ms)
                        .slideX(begin: 0.1, end: 0),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatisticsCard({
    required BuildContext context,
    required String title,
    required List<String> content,
    required IconData icon,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        color: backGroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.blue.shade700, size: screenWidth * 0.08),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    ...content.map((item) => Text(
                          item,
                          style: TextStyle(
                            color: Colors.blue.shade600,
                            fontSize: screenWidth * 0.035,
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceRankCard({
    required BuildContext context,
    required String title,
    required AttendanceOverallProvider provider,
    required bool mostAttended,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final topPlayers =
        provider.getTopAttendedPlayers(mostAttended: mostAttended);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        color: backGroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ExpansionTile(
          title: Row(
            children: [
              Icon(
                mostAttended ? Icons.trending_up : Icons.trending_down,
                color: mostAttended ? Colors.green : Colors.red,
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                '$title (${topPlayers.length})',
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          children: topPlayers.map((entry) {
            PlayerModel player =
                provider.allPlayer.firstWhere((p) => p.id == entry.key);
            return ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenWidth * 0.015,
              ),
              leading: player.userProfile.isNotEmpty
                  ? CircleAvatar(
                      radius: screenWidth * 0.06,
                      backgroundImage: NetworkImage(player.userProfile),
                      backgroundColor: Colors.blue.shade100,
                    )
                  : CircleAvatar(
                      radius: screenWidth * 0.06,
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(
                        Icons.person,
                        color: Colors.blue.shade700,
                        size: screenWidth * 0.06,
                      ),
                    ),
              title: Text(
                player.name,
                style: TextStyle(
                  color: Colors.blue.shade800,
                  fontSize: screenWidth * 0.035,
                ),
              ),
              trailing: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenWidth * 0.015,
                ),
                decoration: BoxDecoration(
                  color:
                      mostAttended ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Attended: ${entry.value} times',
                  style: TextStyle(
                    color: mostAttended
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

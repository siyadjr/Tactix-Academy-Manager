import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Attendence/Widgets/attendance_date_list.dart';
import 'package:tactix_academy_manager/View/Attendence/Widgets/attendance_empty_data.dart';

// widgets/attendance_date_section.dart
class AttendanceDateSection extends StatelessWidget {
  final String title;
  final List<String> dates;
  final IconData iconData;
  final Color iconColor;

  const AttendanceDateSection({
    super.key,
    required this.title,
    required this.dates,
    required this.iconData,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(iconData, color: iconColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: mainTextColour,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${dates.length} days',
                    style: TextStyle(
                      color: iconColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (dates.isEmpty)
            const EmptyDatesList()
          else
            DatesList(
              dates: dates,
              iconData: iconData,
              iconColor: iconColor,
            ),
        ],
      ),
    );
  }
}

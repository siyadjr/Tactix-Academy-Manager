import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DatesList extends StatelessWidget {
  final List<String> dates;
  final IconData iconData;
  final Color iconColor;

  const DatesList({
    super.key,
    required this.dates,
    required this.iconData,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dates.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(iconData, color: iconColor, size: 20),
          ),
          title: Text(
            dates[index],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}
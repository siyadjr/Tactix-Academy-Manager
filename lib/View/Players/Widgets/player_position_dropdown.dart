import 'dart:ui';

import 'package:flutter/material.dart';

class FootballPosition {
  final String name;
  final String abbreviation;

  const FootballPosition({
    required this.name,
    required this.abbreviation,
  });
}

class FootballPositions {
  static const List<FootballPosition> positions = [
    FootballPosition(name: 'Goalkeeper', abbreviation: 'GK'),
    FootballPosition(name: 'Defender', abbreviation: 'Def'),
    FootballPosition(name: 'Midfielder', abbreviation: 'Cm'),
    FootballPosition(name: 'Winger', abbreviation: 'Wf'),
    FootballPosition(name: 'Forward', abbreviation: 'St'),
  ];
}

class PositionSelectorField extends StatelessWidget {
  final String label;
  final String? value;
  final Function(String?) onChanged;
  final Color textColor;
  final Color backgroundColor;

  const PositionSelectorField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: textColor.withOpacity(0.5),
                ),
                color: backgroundColor.withOpacity(0.5),
              ),
              child: Center(
                child: DropdownButtonFormField<String>(
                  value: value,
                  decoration: InputDecoration(
      
                    prefixIcon: Icon(Icons.sports_soccer, color: textColor),
                    border: InputBorder.none,
                    // contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  dropdownColor: backgroundColor,
                  style: TextStyle(color: textColor),
                  items: FootballPositions.positions.map((position) {
                    return DropdownMenuItem(
                      value: position.abbreviation,
                      child: Text(
                        '${position.name} (${position.abbreviation})',
                        style: TextStyle(color: textColor),
                      ),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EmptyDatesList extends StatelessWidget {
  const EmptyDatesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'No records found',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
    );
  }
}

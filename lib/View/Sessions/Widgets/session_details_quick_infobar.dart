import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tactix_academy_manager/Model/Models/session_model.dart';

class SessionQuickInfoBar extends StatelessWidget {
  const SessionQuickInfoBar({
    super.key,
    required this.session,
    required this.sessionDate,
  });

  final SessionModel session;
  final DateTime? sessionDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.access_time, color: Colors.white70, size: 16),
        const SizedBox(width: 8),
        Text(
          sessionDate != null
              ? DateFormat('MMM d, yyyy').format(sessionDate!)
              : 'Invalid Date',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 16),
        const Icon(Icons.location_on, color: Colors.white70, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            session.location,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

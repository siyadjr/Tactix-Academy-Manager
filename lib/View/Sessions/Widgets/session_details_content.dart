import 'package:flutter/material.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_left.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_up.dart';
import 'package:intl/intl.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Model/Models/session_model.dart';
import 'package:tactix_academy_manager/View/Sessions/Widgets/session_detail_infotile.dart';
import 'package:tactix_academy_manager/View/Sessions/Widgets/session_details_action_button.dart';

class SessionDetailsContents extends StatelessWidget {
  const SessionDetailsContents({
    super.key,
    required this.session,
    required this.sessionDate,
  });

  final SessionModel session;
  final DateTime? sessionDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInLeft(
          // delay: Duration(milliseconds: 200),
          child: SessionDetailsInfoTile(
            icon: Icons.location_on,
            text: session.location,
            color: iconColour,
          ),
        ),
        const SizedBox(height: 20),
        FadeInLeft(
          // delay: Duration(milliseconds: 400),
          child: SessionDetailsInfoTile(
            icon: Icons.calendar_today,
            text: sessionDate != null
                ? DateFormat('EEEE, MMMM d, yyyy').format(sessionDate!)
                : 'Invalid Date',
            color: iconColour,
          ),
        ),
        const SizedBox(height: 32),
        FadeInLeft(
          // delay: Duration(milliseconds: 600),
          child: const Text(
            'Description',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        FadeInUp(
          // delay: Duration(milliseconds: 800),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Text(
              session.description,
              style: const TextStyle(
                fontSize: 16,
                color:blackColor,
                height: 1.8,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SessionDetailsActionButtons(session: session),
      ],
    );
  }
}

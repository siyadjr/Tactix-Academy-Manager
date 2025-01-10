import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_up.dart';
import 'package:tactix_academy_manager/Controller/add_session_controller.dart';
import 'package:tactix_academy_manager/Core/ReusableWidgets/custom_dialogue.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/sessions_database.dart';
import 'package:tactix_academy_manager/Model/Models/session_model.dart';
import 'package:tactix_academy_manager/View/Sessions/edit_sessions.dart';

class SessionDetailsActionButtons extends StatelessWidget {
  const SessionDetailsActionButtons({
    super.key,
    required this.session,
  });

  final SessionModel session;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                CustomDialog.showCustomDialog(
                  context: context,
                  imageUrl: 'Assets/Animation - 1736160028902.gif',
                  title: 'Delete',
                  content: 'Do you want to delete this session?',
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);

                        SessionsDatabase().deleteSession(session);

                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: backGroundColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete,
                    color: iconColour,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Delete Session',
                    style: TextStyle(
                      fontSize: 16,
                      color: secondTextColour,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          OutlinedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: backGroundColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => EditSessions(
                              session: session,
                            )));
              },
              child: const Icon(
                Icons.edit,
                color: iconColour,
                size: 24,
              )),
        ],
      ),
    );
  }
}

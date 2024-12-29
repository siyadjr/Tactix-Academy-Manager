import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Model/Models/session_model.dart';

class SessionCard extends StatelessWidget {
  final SessionModel session;

  const SessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Card(
        color: Color.fromARGB(255, 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Row(
          children: [
            // Left side: Image in a container
            Container(
              width: 180,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(session.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16), // Space between image and text

            // Right side: Column with session name, description, and additional details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Session Name
                    Text(
                      session.name,
                      style: const TextStyle(
                          color: secondTextColour,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                        height: 8), // Space between name and description

                    Text(
                      session.location,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                        height:
                            12), // Space before session type or additional info

                    // Optional Session Type or other info
                    Row(
                      children: [
                        Icon(
                          Icons.event_available,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          session.sessionType,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
              onPressed: () {
                // Handle session tap, e.g., navigate to session details
              },
            ),
          ],
        ),
      ),
    );
  }
}

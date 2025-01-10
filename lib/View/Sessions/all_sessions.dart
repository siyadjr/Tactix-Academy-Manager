import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/sessions_database.dart';
import 'package:tactix_academy_manager/View/Sessions/Widgets/sessions_card.dart';
import 'package:tactix_academy_manager/View/Sessions/add_sessions.dart';
import 'package:tactix_academy_manager/Model/Models/session_model.dart';
import 'package:tactix_academy_manager/View/Sessions/sessions_details.dart';
import 'package:tactix_academy_manager/Controller/add_session_controller.dart'; // Assuming AddSessionController is defined here.

class AllSessions extends StatelessWidget {
  const AllSessions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Sessions',
          style: secondaryTextTheme,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<AddSessionController>(
          builder: (context, addSessionController, child) {
            return FutureBuilder<List<SessionModel>>(
              future: SessionsDatabase().fetchSessions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return EmptyStateWidget(
                    onAddPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => const AddSessions()),
                    ),
                  );
                } else {
                  final sessions = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      return SessionCard(
                        session: session,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) =>
                                  SessionsDetails(session: session),
                            ),
                          ).then(
                              (_) => addSessionController.notifiyListeners());
                        },
                      );
                    },
                  );
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => const AddSessions()),
        ).then((_) {
          // Use the existing provider instance
          context.read<AddSessionController>().notifyListeners();
        }),
        label: const Text('New Session'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onAddPressed;

  const EmptyStateWidget({
    super.key,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_note_outlined,
                size: 80,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Sessions Yet',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              'Start by creating your first session. You can manage all your events here.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

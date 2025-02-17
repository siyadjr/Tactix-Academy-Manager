import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/home_screen_provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/team_profile_controller.dart';


class TeamNameCardWidget extends StatelessWidget {
  final dynamic team;
  final TeamProfileController provider;

  const TeamNameCardWidget({
    Key? key,
    required this.team,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showEditDialog(
        context,
        'Team Name',
        team.teamName,
        (value) => provider.updateTeamName(value),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.teamName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to edit',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(Icons.edit, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    String title,
    String currentValue,
    Function(String) onSave,
  ) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Edit $title',
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[600]!),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
              context.read<TeamProvider>().fetchTeamNameAndPhoto();
            },
            child: const Text('Save', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}

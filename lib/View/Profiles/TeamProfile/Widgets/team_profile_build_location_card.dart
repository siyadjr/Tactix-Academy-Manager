import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/home_screen_provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/team_profile_controller.dart';


class LocationCardWidget extends StatelessWidget {
  final dynamic team;
  final TeamProfileController provider;

  const LocationCardWidget({
    Key? key,
    required this.team,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showEditDialog(
        context,
        'Location',
        team.teamLocation,
        (value) => provider.updateTeamLocation(value),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.blue, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.teamLocation,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
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

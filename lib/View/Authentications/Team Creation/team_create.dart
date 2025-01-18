import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/team_creation_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Core/Theme/custom_scaffold.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/team_database.dart';
import 'package:tactix_academy_manager/Model/Normal%20Functions/custom_showdialogue.dart';
import 'package:tactix_academy_manager/Model/Normal%20Functions/team_normal_function.dart';
import 'package:tactix_academy_manager/View/Authentications/Team%20Creation/Widgets/team_create_welcome.dart';
import 'package:tactix_academy_manager/View/Authentications/Team%20Creation/Widgets/team_photo_upload_container.dart';
import 'package:tactix_academy_manager/View/HomeScreen/home_screen.dart';
import 'Widgets/create_team_textfield.dart';
import 'Widgets/info_card.dart';

class TeamCreate extends StatelessWidget {
  const TeamCreate({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeamCreationProvider>(context, listen: true);
    final TextEditingController teamNameController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return CustomScaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const TeamCreateWelcome(),
                const SizedBox(height: 20),
                _buildImageUploadSection(provider),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CreateTeamTexttField(
                        label: "TEAM NAME",
                        hintText: "Enter your team name",
                        icon: Icons.sports_soccer,
                        controller: teamNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Team name is required";
                          }
                          if (value.length < 3) {
                            return "Team name must be at least 3 characters long";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CreateTeamTexttField(
                        label: "LOCATION",
                        hintText: "Enter your location",
                        icon: Icons.location_on,
                        controller: locationController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Location is required";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (provider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                _addTeam(
                                  context,
                                  teamNameController.text,
                                  locationController.text,
                                  provider,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainTextColour,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 8,
                        shadowColor: mainTextColour,
                      ),
                      child: provider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.sports_basketball),
                                SizedBox(width: 8),
                                Text(
                                  "CREATE SQUAD",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                const SizedBox(height: 20),
                const InfoCard(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildImageUploadSection(TeamCreationProvider provider) {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildImageContainer(
          onTap: () {
            provider.pickImage();
          },
          child: provider.uploadedImagePath != provider.defaultImagePath
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    File(provider.uploadedImagePath),
                    fit: BoxFit.cover,
                  ),
                )
              : const TeamPhotoUploadContainer(),
        ),
        const SizedBox(width: 20),
        _buildImageContainer(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'Assets/default_team.logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildImageContainer({Widget? child, VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: mainTextColour, width: 2),
        boxShadow: [
          BoxShadow(
            color: mainTextColour.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    ),
  );
}

Future<void> _addTeam(BuildContext context, String teamName, String location,
    TeamCreationProvider provider) async {
  provider.setLoading(true);

  try {
    await teamCreationFunction(teamName, location, provider.uploadedImagePath);
    String teamId = await TeamDatabase().getTeamId();

    log(provider.uploadedImagePath);

    // Show custom dialog with team ID
    showTeamIdDialog(
      context: context,
      teamId: teamId,
      onNavigate: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) => const HomeScreen()),
          (_) => true,
        );
      },
    );
  } catch (e) {
    log("Error creating team: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to create team. Please try again.")),
    );
  } finally {
    provider.setLoading(false);
  }
}

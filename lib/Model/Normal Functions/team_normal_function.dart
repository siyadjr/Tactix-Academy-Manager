import 'dart:developer';

import 'package:tactix_academy_manager/Controller/Api/cloudinery_class.dart';
import 'package:tactix_academy_manager/Model/Firebase/Authentication%20funcations/user.db.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/team_database.dart';
import 'package:tactix_academy_manager/Model/Models/team_model.dart';

Future<void> teamCreationFunction(
    String teamName, String teamLocation, String teamPhoto) async {
  try {
    final managerId = await UserDatbase().getUserDocId();

    if (managerId == null) {
      log("Manager ID not found.");
      throw Exception("Manager ID is null. Cannot create team.");
    }

    final String? uploadedPhotoUrl =
        await CloudineryClass().uploadTeamPhoto(teamPhoto);

    if (uploadedPhotoUrl == null) {
      log("Team photo upload failed. Team creation aborted.");
      return; // Stop execution if photo upload fails
    }

    TeamModel newTeam = TeamModel(
      managerId: managerId,
      name: teamName,
      location: teamLocation,
      teamPhoto: uploadedPhotoUrl,
    );

    await TeamDatabase().createTeam(newTeam);
    log("Team created successfully with photo URL: $uploadedPhotoUrl");
  } catch (e) {
    log("Error creating team: $e");
  }
}
 Future<String?> fetchTeamId() async {
    try {
      String fetchedTeamId = await TeamDatabase().getTeamId();
    
    
      return fetchedTeamId;
    } catch (e) {
      log('Error fetching team ID: $e');
   
    }
  }

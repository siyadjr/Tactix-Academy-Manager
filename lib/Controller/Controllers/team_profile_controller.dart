import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Api/cloudinery_class.dart';
import 'package:tactix_academy_manager/Controller/Controllers/home_screen_provider.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/team_database.dart';
import 'package:tactix_academy_manager/Model/Models/team_full_model.dart';

class TeamProfileController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TeamFullModel? _team;
  TeamFullModel? get team => _team;

  final TeamDatabase _teamDatabase = TeamDatabase();
  final ImagePicker _imagePicker = ImagePicker();

  // Get team details
  Future<void> getTeamDetails() async {
    try {
      _setLoading(true);
      _team = await _teamDatabase.getTeamDetails();
      if (_team != null) {
        log('Team Details Fetched: ${_team!.teamName}');
      }
    } catch (e) {
      log('Error fetching team details: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update team name
  Future<void> updateTeamName(String newName) async {
    try {
      _setLoading(true);
      await _teamDatabase.updateTeamName(newName);
      if (_team != null) {
        _team = _team!.copyWith(teamName: newName);
        log('Team name updated to: $newName');
      }

      notifyListeners();
    } catch (e) {
      log('Error updating team name: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update team location
  Future<void> updateTeamLocation(String newLocation) async {
    try {
      _setLoading(true);
      await _teamDatabase.updateTeamLocation(newLocation);
      if (_team != null) {
        _team = _team!.copyWith(teamLocation: newLocation);
        log('Team location updated to: $newLocation');
      }
      notifyListeners();
    } catch (e) {
      log('Error updating team location: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Pick and update team photo
  Future<void> pickImage(ImageSource source, BuildContext context) async {
    final provider = Provider.of<TeamProvider>(context, listen: false);
    try {
      _setLoading(true);
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        final imageUrl = await CloudineryClass().uploadPhoto(pickedFile.path);
        if (imageUrl != null) {
          await TeamDatabase().updateTeamLogo(imageUrl);
          _team = _team!.copyWith(teamPhoto: imageUrl);

          notifyListeners();
        }
      }
    } catch (e) {
      log('Error picking/uploading image: $e');
    } finally {
      provider.fetchTeamNameAndPhoto();
      _setLoading(false);
    }
  }

  Future<void> removeCurrentPhoto(BuildContext context) async {
    final provider = Provider.of<TeamProvider>(context, listen: false);
    try {
      _setLoading(true);

      const imageUrl =
          'https://res.cloudinary.com/dplpu9uc5/image/upload/v1735571338/wkjszoqsurn9w8eeujxj.jpg';
      await TeamDatabase().updateTeamLogo(imageUrl);
      _team = _team!.copyWith(teamPhoto: imageUrl);

      notifyListeners();
    } catch (e) {
      log('Error picking/uploading image: $e');
    } finally {
      provider.fetchTeamNameAndPhoto();
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

extension TeamFullModelExtension on TeamFullModel {
  TeamFullModel copyWith({
    String? id,
    String? teamName,
    String? teamLocation,
    String? teamPhoto,
    int? teamPlayersCount,
  }) {
    return TeamFullModel(
      id: id ?? this.id,
      teamName: teamName ?? this.teamName,
      teamLocation: teamLocation ?? this.teamLocation,
      teamPhoto: teamPhoto ?? this.teamPhoto,
      teamPlayersCount: teamPlayersCount ?? this.teamPlayersCount,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/players_database.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';

class PlayerDetailsController extends ChangeNotifier {
  PlayerModel? _player;
  bool _isLoading = false;
  String? _error;

  PlayerModel? get player => _player;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchData(String playerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // Notify UI that it's loading

    try {
      _player = await PlayerDatabase().getPlayerDetails(playerId);
    } catch (e) {
      _error = 'Failed to fetch player details: $e';
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI to rebuild with fetched data
    }
  }


}

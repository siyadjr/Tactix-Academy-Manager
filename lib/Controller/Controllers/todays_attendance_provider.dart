import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/attendence_db.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/players_database.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';

class TodaysAttendanceProvider extends ChangeNotifier {
  Map<String, dynamic> _todaysAttendance = {};
  Map<String, dynamic> get todaysAttendance => _todaysAttendance;
  List<PlayerModel> _allPlayers = [];
  List<PlayerModel> get allPlayers => _allPlayers;
  List<PlayerModel> _todayAttendedPlayers = [];
  List<PlayerModel> get todayAttendedPlayers => _todayAttendedPlayers;
  List<PlayerModel> _todayAbsentPlayers = [];
  List<PlayerModel> get todaysAbsentPlayers => _todayAbsentPlayers;
  List<String> _attendedPlayers = [];
  List<String> get attendedPlayers => _attendedPlayers;
  bool _stasticsIsLoading = false;
  bool get stasticsIsloading => _stasticsIsLoading;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchTodaysAttendance() async {
    _isLoading = true;
    notifyListeners();

    try {
      _todaysAttendance = await AttendanceDb().getTodaysAttendance() ?? {};

      _attendedPlayers =
          List<String>.from(_todaysAttendance['attendedPlayers'] ?? []);
    } catch (e) {
      log("Error fetching attendance: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAllStatistics() async {
  _stasticsIsLoading = true;
  notifyListeners();

  try {
    // Fetch all players
    _allPlayers = await PlayerDatabase().getAllPlayers();

    // Fetch attended players
    _todayAttendedPlayers =
        _allPlayers.where((player) => _attendedPlayers.contains(player.id)).toList();

    // Fetch absent players (not in attendedPlayers list)
    _todayAbsentPlayers =
        _allPlayers.where((player) => !_attendedPlayers.contains(player.id)).toList();

    _stasticsIsLoading = false;
    notifyListeners();
  } catch (e) {
    log("Error fetching statistics: $e");
    _stasticsIsLoading = false;
    notifyListeners();
  }
}

}

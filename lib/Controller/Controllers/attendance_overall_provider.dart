import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team Database/players_database.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team Database/attendence_db.dart';

class AttendanceOverallProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<PlayerModel> _allPlayer = [];
  List<PlayerModel> get allPlayer => _allPlayer;

  int _totalPlayers = 0;
  int get totalPlayers => _totalPlayers;
  PlayerModel player = PlayerModel(
      id: 'id',
      name: 'name',
      email: 'email',
      fit: 'fit',
      matches: 'matches',
      achivements: [],
      goals: 'goals',
      assists: 'assists',
      number: 'number',
      position: 'position',
      rank: 'rank',
      teamId: 'teamId',
      userProfile: 'userProfile');
  int _totalAttendanceSessions = 0;
  int get totalAttendanceSessions => _totalAttendanceSessions;

  Map<String, int> _individualPlayerAttendance = {};
  Map<String, int> get individualPlayerAttendance =>
      _individualPlayerAttendance;

  double _overallAttendanceRate = 0.0;
  double get overallAttendanceRate => _overallAttendanceRate;

  Future<void> fetchOverallAttendanceStatistics() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch all players
       _allPlayer = await PlayerDatabase().getAllPlayers();
      player = _allPlayer[0];
      _totalPlayers = _allPlayer.length;

      // Fetch all attendance records
      final allAttendanceRecords = await AttendanceDb().getAttendanceAsModel();
      _totalAttendanceSessions = allAttendanceRecords.length;

      // Initialize individual player attendance tracking
      _individualPlayerAttendance = {
        for (var player in _allPlayer) player.id ?? '': 0
      };

      // Count attendance for each player across all sessions
      for (var attendance in allAttendanceRecords) {
        final attendedPlayerIds = attendance.attendedPlayers ?? [];

        for (var playerId in attendedPlayerIds) {
          if (_individualPlayerAttendance.containsKey(playerId)) {
            _individualPlayerAttendance[playerId] =
                (_individualPlayerAttendance[playerId] ?? 0) + 1;
          }
        }
      }

      // Calculate overall attendance rate
      final totalPossibleAttendances = _totalPlayers * _totalAttendanceSessions;
      final totalActualAttendances =
          _individualPlayerAttendance.values.reduce((a, b) => a + b);

      _overallAttendanceRate = totalPossibleAttendances > 0
          ? (totalActualAttendances / totalPossibleAttendances) * 100
          : 0.0;
    } catch (e) {
      print("Error fetching overall attendance statistics: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<MapEntry<String, int>> getTopAttendedPlayers(
      {int limit = 5, bool mostAttended = true}) {
    final sortedAttendance = _individualPlayerAttendance.entries.toList()
      ..sort((a, b) => mostAttended
          ? b.value.compareTo(a.value)
          : a.value.compareTo(b.value));

    return sortedAttendance.take(limit).toList();
  }
}

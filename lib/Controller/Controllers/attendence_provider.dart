import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/attendence_db.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/players_database.dart';
import 'package:tactix_academy_manager/Model/Models/attendance_model.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';

class AttendanceProvider extends ChangeNotifier {
  String? _selectedDate;
  String? _selectedTime;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isPlayerFetching = false;
  bool get isPlayerFetching => _isPlayerFetching;

  List<PlayerModel> _allPlayers = [];
  List<PlayerModel> get allPlayers => _allPlayers;

  List<PlayerModel> _attendedPlayers = [];
  List<PlayerModel> get attendedPlayers => _attendedPlayers;

  List<PlayerModel> _absentPlayers = [];
  List<PlayerModel> get absentPlayers => _absentPlayers;

  List<AttendanceModel> _attendance = [];
  List<AttendanceModel> get attendances => _attendance;

  String? get selectedDate => _selectedDate;
  String? get selectedTime => _selectedTime;

  void setDate(DateTime date) {
    _selectedDate = "${date.day}/${date.month}/${date.year}";
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    _selectedTime = "${time.hour}:${time.minute}";
    notifyListeners();
  }

  Future<void> fetchAttendance() async {
    _isLoading = true;
    notifyListeners();
    try {
      _attendance = await AttendanceDb().getAttendanceAsModel();
    } catch (e) {
      log("Error fetching attendance: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAttendedPlayers(List<dynamic> playerIds) async {
    _isPlayerFetching = true;
    notifyListeners();
    try {
      _allPlayers = await PlayerDatabase().getAllPlayers();

      // Clear existing data before populating
      _attendedPlayers.clear();
      _absentPlayers.clear();

      for (var player in _allPlayers) {
        if (playerIds.contains(player.id)) {
          _attendedPlayers.add(player);
        } else {
          _absentPlayers.add(player);
        }
      }
    } catch (e) {
      log("Error fetching players: $e");
    } finally {
      _isPlayerFetching = false;
      notifyListeners();
    }
  }

  Future<void> addAttendance(BuildContext context) async {
    if (_selectedDate == null || _selectedTime == null) {
      log("Please select both date and time.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both date and time.'),
        ),
      );
      return;
    }

    try {
      final result =
          await AttendanceDb().addAttendance(_selectedDate!, _selectedTime!);
      String message = result
          ? "Attendance added for $_selectedDate"
          : "Attendance already marked for $_selectedDate";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: backGroundColor,
          content: Text(message),
        ),
      );

      if (result) await fetchAttendance();
    } catch (e) {
      log("Error adding attendance: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to add attendance: $e"),
        ),
      );
    }
  }

  Future<void> deleteAttendance(String attendanceId) async {
    await AttendanceDb().deleteAttendance(attendanceId);
  }
}

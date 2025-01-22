import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/attendence_db.dart';

class AttendanceProvider extends ChangeNotifier {
  String? _selectedDate;
  String? _selectedTime;
  List<Map<String, dynamic>> _attendanceList = [];
  Map<String, dynamic> _todaysAttendance = {};
  String? get selectedDate => _selectedDate;

  String? get selectedTime => _selectedTime;
  List<Map<String, dynamic>> get attendanceList => _attendanceList;
  Map<String, dynamic> get todaysAttendance => _todaysAttendance;
  void setDate(DateTime date) {
    _selectedDate = "${date.day}/${date.month}/${date.year}";
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    _selectedTime = "${time.hour}:${time.minute}";
    notifyListeners();
  }

  Future<void> fetchAttendance() async {
    _attendanceList = await AttendanceDb().getAttendance();

    notifyListeners();
  }

  Future<void> addAttendance(BuildContext context) async {
    if (_selectedDate != null && _selectedTime != null) {
      try {
        final result =
            await AttendanceDb().addAttendance(_selectedDate!, _selectedTime!);
        if (!result) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: backGroundColor,
              content: Text('Attendance already marked for $_selectedDate'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: backGroundColor,
              content: Text('Attendance added for $_selectedDate'),
            ),
          );
          await fetchAttendance();
        }
      } catch (e) {
        log("Error adding attendance: $e");
      }
    } else {
      log("Please select both date and time.");
    }
  }
}

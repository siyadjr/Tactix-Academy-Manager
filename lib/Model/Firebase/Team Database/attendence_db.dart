import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/team_database.dart';
import 'package:intl/intl.dart'; // Import this for date formatting

class AttendanceDb {
  Future<bool> addAttendance(String date, String time) async {
    final teamId = await TeamDatabase().getTeamId();
    if (teamId != null) {
      // Format the date to a valid Firestore document ID (yyyy-MM-dd)
      String formattedDate = date.replaceAll('/', '');

      // Check if the attendance with the same date already exists
      final existingDoc = await FirebaseFirestore.instance
          .collection('Teams')
          .doc(teamId)
          .collection('Attendance')
          .doc(formattedDate)
          .get();

      // If the document exists, return false (attendance already added)
      if (existingDoc.exists) {
        log("Attendance already exists for $formattedDate.");
        return false;
      } else {
        // If the document does not exist, add the attendance
        FirebaseFirestore.instance
            .collection('Teams')
            .doc(teamId)
            .collection('Attendance')
            .doc(formattedDate)
            .set({'date': date, 'time': time, 'attendedPlayers': []}).then((_) {
          log("Attendance for $formattedDate added successfully.");
        }).catchError((error) {
          log("Error adding attendance: $error");
        });
        return true; // Successfully added the attendance
      }
    } else {
      log("Team ID is not available.");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAttendance() async {
    final teamId = await TeamDatabase().getTeamId();
    if (teamId != null) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('Teams')
            .doc(teamId)
            .collection('Attendance')
            .get();

        List<Map<String, dynamic>> attendanceList = [];
        snapshot.docs.forEach((doc) {
          attendanceList.add(doc.data());
        });

        return attendanceList;
      } catch (e) {
        log("Error fetching attendance: $e");
        return [];
      }
    } else {
      log("Team ID is not available.");
      return [];
    }
  }
   Future<Map<String, dynamic>> getTodaysAttendance() async {
    final teamId = await TeamDatabase().getTeamId();
    final date = DateTime.now();
    final selectedDate = "${date.day}/${date.month}/${date.year}";

    String formattedDate = selectedDate.replaceAll('/', '');
    log(formattedDate);

    if (teamId != null) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('Teams')
            .doc(teamId)
            .collection('Attendance')
            .doc(formattedDate)
            .get();
        final data = snapshot.data();
        if (data != null) {
          log('$data');
          return data;
        } else {
          log("No data found for this date.");
          return <String, dynamic>{};
        }
      } catch (e) {
        log("Error fetching attendance: $e");
        return <String, dynamic>{};
      }
    } else {
      log("Team ID is not available.");
      return <String, dynamic>{};
    }
  }
}

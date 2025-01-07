import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tactix_academy_manager/Controller/Api/cloudinery_class.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/sessions_database.dart';
import 'package:tactix_academy_manager/Model/Models/session_model.dart';
import 'package:tactix_academy_manager/View/Sessions/all_sessions.dart';

class AddSessionController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  DateTime? selectedDate;
  final picker = ImagePicker();

  String type = 'Training';
  File? image;
  bool isSubmitting = false;

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1200,
      );
      if (pickedFile != null) {
        image = File(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  bool validateDate() {
    if (selectedDate == null) {
      return false; // No date selected
    }

    final now = DateTime.now();
    if (selectedDate!.isBefore(now)) {
      return false; // Date is in the past
    }

    return true;
  }

  void notifiyListeners() {
    notifiyListeners();
  }

  Future<void> submitSession(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    if (selectedDate == null || !validateDate()) {
      _showErrorSnackBar(
          context, 'Please select a valid date (not in the past)');
      return;
    }

    if (image == null) {
      _showErrorSnackBar(context, 'Please select an image');
      return;
    }

    isSubmitting = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final photo = await CloudineryClass().uploadPhoto(image!.path);
      final session = SessionModel(
        id: '',
        name: nameController.text,
        description: descriptionController.text,
        sessionType: type,
        date: selectedDate.toString(),
        imagePath: photo.toString(),
        location: locationController.text,
      );
      await SessionsDatabase().addSessions(session);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (ctx) =>
                  const AllSessions())); // Close the screen after submission
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to save session: $e');
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: backGroundColor,
      ),
    );
  }

  @override
  String toString() {
    return '''
      Name: ${nameController.text}
      Description: ${descriptionController.text}
      Location: ${locationController.text}
      Type: $type
      Image: ${image?.path}
    ''';
  }
}

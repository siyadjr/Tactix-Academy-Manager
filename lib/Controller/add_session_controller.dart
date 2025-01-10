import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Api/cloudinery_class.dart';
import 'package:tactix_academy_manager/Controller/session_details_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Core/important_data.dart';
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

// Remove this misspelled method
notifiyListeners() {  // Remove this
  notifyListeners();
}

// Just use notifyListeners() directly where needed

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

      context.read<AddSessionController>().notifiyListeners();

      Navigator.pop(context);
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to save session: $e');
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> editSession(
    BuildContext context,
    SessionModel session,
    String name,
    String location,
    String description,
    DateTime date,
    String sessionType,
  ) async {
    if (!formKey.currentState!.validate()) return;

    if (selectedDate == null || !validateDate()) {
      _showErrorSnackBar(
          context, 'Please select a valid date (not in the past)');
      return;
    }

    isSubmitting = true;
    notifyListeners();

    try {
      // Upload the image only if a new one is provided
      String? updatedImagePath = session.imagePath;
      if (editedImage != '') {
        updatedImagePath = await CloudineryClass().uploadPhoto(editedImage);
        log(updatedImagePath!);
      }

      // Update the session with new or existing data
      final editedSession = SessionModel(
        id: session.id,
        name: name,
        description: description,
        sessionType: sessionType,
        date: date.toString(),
        imagePath: updatedImagePath,
        location: location,
      );
      log(editedSession.toString());
      await SessionsDatabase().updatedSession(editedSession);

      context.read<AddSessionController>().notifyListeners();
      await context.read<SessionDetailsProvider>().updateSession(editedSession);

      // Navigate back to the previous screen
      editedImage = '';
      Navigator.pop(context);
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to update session: $e');
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

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }
}

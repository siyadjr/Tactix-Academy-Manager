import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tactix_academy_manager/Controller/Api/cloudinery_class.dart';
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

  Future<void> submitSession(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    if (image == null) {
      _showErrorSnackBar(context, 'Please select an image');
      return;
    }

    isSubmitting = true;
    notifyListeners();

    try {
      await Future.delayed(
          const Duration(seconds: 1)); // Simulated network delay

      final photo = await CloudineryClass().uploadPhoto(image!.path);
      final session = SessionModel(
          name: nameController.text,
          description: descriptionController.text,
          sessionType: type,
          date: selectedDate.toString(),
          imagePath: photo.toString(),
          location: locationController.text);
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
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error),
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

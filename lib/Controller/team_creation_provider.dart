import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TeamCreationProvider extends ChangeNotifier {
  String? _uploadedImagePath;
  final String defaultImagePath = 'https://res.cloudinary.com/dplpu9uc5/image/upload/v1734509219/default_team.logo_pz18h6.jpg';

  // Getter to expose the currently selected image (uploaded or default)
  String get uploadedImagePath => _uploadedImagePath ?? defaultImagePath;
   bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Method to pick an image
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _uploadedImagePath = pickedImage.path;
      notifyListeners(); // Notify listeners about the change
    }
  }
}

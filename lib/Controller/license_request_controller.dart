import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Controller/Api/cloudinery_class.dart';

class LicenseRequestController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Function to start and stop loading
  Future<void> requestLicense(String imagePath) async {
    if (imagePath.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Your logic to upload the license here
      await CloudineryClass().uploadLicense(imagePath);
    } catch (e) {
      // Handle error
      print("Failed to upload license: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

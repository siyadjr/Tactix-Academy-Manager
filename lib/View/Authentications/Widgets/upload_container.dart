import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/license_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

class UploadContainer extends StatelessWidget {
  const UploadContainer({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Consumer<LicenseProvider>(
      builder: (context, licenseProvider, child) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: primaryColor.withOpacity(0.05),
          border: Border.all(
            color: mainTextColour.withOpacity(0.2),
            width: 1.5,
          ),
          image: licenseProvider.selectedImage != null
              ? DecorationImage(
                  image: FileImage(licenseProvider.selectedImage!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (licenseProvider.selectedImage == null)
                Icon(
                  Icons.cloud_upload,
                  size: 80,
                  color: mainTextColour.withOpacity(0.8),
                ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  _showImageSourceBottomSheet(context, licenseProvider);
                },
                icon: const Icon(Icons.upload_file, color: Colors.white),
                label: const Text(
                  "Upload License",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainTextColour,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Supported formats: JPEG, PNG",
                style: TextStyle(
                  fontSize: 12,
                  color: secondTextColour.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceBottomSheet(
      BuildContext context, LicenseProvider licenseProvider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  licenseProvider.pickImage(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  licenseProvider.pickImage(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

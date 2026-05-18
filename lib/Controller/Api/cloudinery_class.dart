import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:cloudinary/cloudinary.dart'
    as cloudinary_sdk; 

import 'package:tactix_academy_manager/Core/Env/env_config.dart';

class CloudineryClass {
  final _cloudinary = cloudinary_sdk.Cloudinary.signedConfig(
    apiKey: EnvConfig.cloudinaryApiKey,
    apiSecret: EnvConfig.cloudinaryApiSecret,
    cloudName: EnvConfig.cloudinaryCloudName,
  );

  Future<void> uploadLicense(String imagePath) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No authenticated user found.");
      }

      final response = await _cloudinary.upload(
        file: imagePath,
        resourceType: cloudinary_sdk.CloudinaryResourceType.image,
      );

      if (response.isSuccessful) {
        final imageUrl = response.secureUrl!;
        log("Image uploaded to Cloudinary: $imageUrl");

        // Update Firestore with Cloudinary URL
        await FirebaseFirestore.instance
            .collection('Managers')
            .doc(user.uid)
            .update({
          'licenseUrl': imageUrl,
          'license status': 'pending',
        });

        log("License uploaded and URL saved successfully.");
      } else {
        log("Failed to upload image to Cloudinary: ${response.error?.toString()}");
      }
    } catch (e) {
      log("Error uploading license: $e");
    }
  }

  Future<String?> uploadPhoto(String imagePath) async {
    final response = await _cloudinary.upload(
      file: imagePath,
      resourceType: cloudinary_sdk.CloudinaryResourceType.image,
    );

    if (response.isSuccessful) {
      final imageUrl = response.secureUrl!;
      return imageUrl;
    }
  }

Future<String?> uploadTeamPhoto(String imagePath) async {
  try {
    final response = await _cloudinary.upload(
      file: imagePath,
      resourceType: cloudinary_sdk.CloudinaryResourceType.image,
    );

    if (response.isSuccessful && response.secureUrl != null) {
      final imageUrl = response.secureUrl!;
      return imageUrl;
    } else {
      log("Failed to upload team photo: ${response.error?.toString()}");
      return null;
    }
  } catch (e) {
    log("Error during Cloudinary upload: $e");
    return null;
  }
}
}

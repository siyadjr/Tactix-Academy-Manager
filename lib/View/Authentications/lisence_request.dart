import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/license_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Core/Theme/button_style.dart';
import 'package:tactix_academy_manager/Core/Theme/custom_scaffold.dart';
import 'package:tactix_academy_manager/Model/Firebase/Authentication%20funcations/user.db.dart';
import 'package:tactix_academy_manager/View/Authentications/Widgets/licence_header.dart';
import 'package:tactix_academy_manager/View/Authentications/Widgets/upload_container.dart';

class CoachingLicenseScreen extends StatelessWidget {
  CoachingLicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const LicenceHeaderFiles(),
              const SizedBox(height: 40),
              UploadContainer(context: context),
              const SizedBox(height: 30),
              Center(child: buildRequestButton(context)),
              const SizedBox(height: 30),
              buildFooterText(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRequestButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final imagePath = context.read<LicenseProvider>().imagePath;
          if (imagePath.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              // ignore: prefer_const_constructors
              SnackBar(
                content: const Text(
                  "Please upload a license before submitting.",
                  textAlign: TextAlign.center,
                ),
                backgroundColor: backGroundColor,
              ),
            );
          } else {
            UserDatbase().uploadLicense(imagePath);
          }
        },
        style: elevatedButtonStyle.copyWith(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        child: const Text(
          "Request License Verification",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildFooterText() {
    return Center(
      child: Text(
        "License evaluation typically takes up to 20 minutes.\nPlease ensure all documents are clear and legible.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: secondTextColour.withOpacity(0.7),
          fontStyle: FontStyle.italic,
          height: 1.5,
        ),
      ),
    );
  }
}

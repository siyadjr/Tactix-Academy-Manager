import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Core/Theme/button_style.dart';
import 'package:tactix_academy_manager/Core/Theme/custom_scaffold.dart';

class CoachingLicenseScreen extends StatelessWidget {
  const CoachingLicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              _buildUploadSection(context),
              const SizedBox(height: 30),
              _buildRequestButton(),
              const SizedBox(height: 20),
              _buildFooterText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          "Coaching License Verification",
          style: TextStyle(
            fontSize: 24,
            color: Colors.purple[800],
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          "Please upload your professional coaching license for evaluation",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: mainTextColour.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.05),
            Colors.purple.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.purple.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          Image.asset(
            'Assets/fitness traking.png', // Assume you have this SVG
            height: 80,
            color: Colors.purple[700],
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              log("Upload clicked");
              // Implement file upload logic
            },
            icon: const Icon(Icons.upload_file, color: Colors.white),
            label: const Text(
              "Upload License",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[700],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          log("Request clicked");
          // Implement request logic
        },
        style: elevatedButtonStyle.copyWith(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
        child: const Text(
          "Request License Verification",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFooterText() {
    return Text(
      "License evaluation typically takes up to 20 minutes.\nPlease ensure all documents are clear and legible.",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        color: secondTextColour.withOpacity(0.7),
        fontStyle: FontStyle.italic,
      ),
    );
  }
}

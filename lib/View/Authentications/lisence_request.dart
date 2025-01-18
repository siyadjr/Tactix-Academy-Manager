import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/license_provider.dart';
import 'package:tactix_academy_manager/Controller/Api/cloudinery_class.dart';
import 'package:tactix_academy_manager/Controller/Controllers/license_request_controller.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Core/Theme/button_style.dart';
import 'package:tactix_academy_manager/Core/Theme/custom_scaffold.dart';
import 'package:tactix_academy_manager/View/Authentications/Widgets/licence_header.dart';
import 'package:tactix_academy_manager/View/Authentications/Widgets/upload_container.dart';
import 'package:tactix_academy_manager/View/Authentications/Team%20Creation/team_create.dart';
import 'package:tactix_academy_manager/View/HomeScreen/home_screen.dart';

class CoachingLicenseScreen extends StatelessWidget {
  const CoachingLicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                _buildLicenseStatusStream(context),
              ],
            ),
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
              const SnackBar(
                content: Text(
                  "Please upload a license before submitting.",
                  textAlign: TextAlign.center,
                ),
                backgroundColor: backGroundColor,
              ),
            );
          } else {
            context.read<LicenseRequestController>().requestLicense(imagePath);
          }
        },
        style: elevatedButtonStyle.copyWith(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        child: Consumer<LicenseRequestController>(
          builder: (context, controller, child) {
            return controller.isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                : const Text(
                    "Request License Verification",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  );
          },
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

  Widget _buildLicenseStatusStream(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Managers')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return const Text('No data available');
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final licenseStatus = data['license status'] ?? 'pending';

        if (licenseStatus == 'approved') {
          Future.delayed(Duration.zero, () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (ctx) => const TeamCreate()),
              (_) => false,
            );
          });
        }

        return Text(
          'License Status: $licenseStatus',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: mainTextColour,
          ),
        );
      },
    );
  }
}

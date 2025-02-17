import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'siyadsiyad016@gmail.com',
      query:
          'subject=Payment Support Request&body=Hello, I need assistance with regarding to privacy policy...',
    );

    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch email');
    }
  }

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(
        'https://www.termsfeed.com/live/f80a2483-a984-484d-978a-19eb5068ef18');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    // You can adjust this color code as needed

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: secondTextColour,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _PolicySection(
                  title: 'Effective Date',
                  content: 'January 1, 2025',
                ),
                const _PolicySection(
                  title: 'Introduction',
                  content:
                      'Tactics Academy ("we", "our", "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and disclose your personal information when you use our application.',
                ),
                const _PolicySection(
                  title: 'Information We Collect',
                  bullets: [
                    'Personal Information: Name, email, phone number, and other details you provide during registration',
                    'Usage Data: Information on how you interact with our app',
                    'Device Information: Device model, OS version, and unique identifiers',
                  ],
                ),
                const _PolicySection(
                  title: 'How We Use Your Information',
                  bullets: [
                    'To provide and improve our services',
                    'To communicate with you',
                    'To ensure security and prevent fraud',
                  ],
                ),
                const _PolicySection(
                  title: 'Sharing Your Information',
                  content:
                      'We do not share your personal information with third parties except as required by law or to provide our services.',
                ),
                const _PolicySection(
                  title: 'Security',
                  content:
                      'We implement security measures to protect your data, but no method is 100% secure.',
                ),
                const _PolicySection(
                  title: 'Your Rights',
                  bullets: [
                    'Access, update, or delete your personal information',
                    'Withdraw consent for data processing',
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _ContactButton(
                        icon: Icons.email_outlined,
                        label: 'Contact Us',
                        onPressed: _launchEmail,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ContactButton(
                        icon: Icons.launch_outlined,
                        label: 'Full Policy',
                        onPressed: _launchURL,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String? content;
  final List<String>? bullets;

  const _PolicySection({
    required this.title,
    this.content,
    this.bullets,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: secondTextColour,
            ),
          ),
          const SizedBox(height: 12),
          if (content != null)
            Text(
              content!,
              style: const TextStyle(
                fontSize: 16,
                color: secondTextColour,
                height: 1.5,
              ),
            ),
          if (bullets != null) ...[
            const SizedBox(height: 8),
            ...bullets!.map((bullet) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Icon(
                          Icons.circle,
                          size: 8,
                          color: secondTextColour,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          bullet,
                          style: const TextStyle(
                            fontSize: 16,
                            color: secondTextColour,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ContactButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
      ),
      label: Text(
        label,
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

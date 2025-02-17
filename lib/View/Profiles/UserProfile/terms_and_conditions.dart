import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';


class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: secondTextColour,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: secondTextColour,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: secondTextColour),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Terms and Conditions',
          style: TextStyle(
            color: secondTextColour,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Terms and Conditions',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: secondTextColour,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Effective Date: 01/01/2025',
                  style: TextStyle(
                    fontSize: 14,
                    color: secondTextColour,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Welcome to Tactics Academy! These terms and conditions outline the rules and regulations for the use of our application.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: secondTextColour,
                  ),
                ),
                const SizedBox(height: 32),
                _buildSection(
                  '1. Acceptance of Terms',
                  'By accessing and using Tactics Academy, you agree to comply with these terms.',
                ),
                _buildSection(
                  '2. User Accounts',
                  '• You must provide accurate information when creating an account.\n'
                      '• You are responsible for maintaining the confidentiality of your account.',
                ),
                _buildSection(
                  '3. Usage Restrictions',
                  '• Do not misuse our services for unlawful purposes.\n'
                      '• Unauthorized access or data collection is prohibited.',
                ),
                _buildSection(
                  '4. Content Ownership',
                  '• All content in the app is owned by Tactics Academy unless otherwise stated.\n'
                      '• Users retain ownership of their own content but grant Tactics Academy a license to use it.',
                ),
                _buildSection(
                  '5. Payments and Fees',
                  '• Managers may set and collect fees from players using our integrated payment system.\n'
                      '• Refunds and disputes are handled as per our payment provider\'s policies.',
                ),
                _buildSection(
                  '6. Limitation of Liability',
                  'We are not liable for any damages arising from the use of our app.',
                ),
                _buildSection(
                  '7. Termination',
                  'We reserve the right to terminate accounts violating these terms.',
                ),
                _buildSection(
                  '8. Changes to Terms',
                  'We may update these terms at any time. Continued use of the app means acceptance of updated terms.',
                ),
                _buildSection(
                  '9. Contact Us',
                  'For any questions regarding these terms, contact us at Contact us page.',
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: secondTextColour.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Make sure to review and understand these terms before using our app.',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: secondTextColour,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

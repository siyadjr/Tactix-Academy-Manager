import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  Future<void> _launchEmail(String email) async {
    final Uri emailLaunchUri =
        Uri(scheme: 'mailto', path: email, queryParameters: {
      'subject': 'Contact Inquiry - Tactics Academy',
    });

    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      debugPrint('Could not launch email: $e');
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phone,
    );

    try {
      await launchUrl(phoneUri);
    } catch (e) {
      debugPrint('Could not launch phone: $e');
    }
  }

  Future<void> _launchWhatsApp(String phone) async {
    final Uri whatsappUri = Uri.parse('https://wa.me/$phone');

    try {
      await launchUrl(whatsappUri);
    } catch (e) {
      debugPrint('Could not launch WhatsApp: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contact Us',
          style: TextStyle(
            color: secondTextColour,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HeaderSection(
                  title: 'Get in Touch',
                  subtitle:
                      'We\'re here to help and answer any questions you might have. We look forward to hearing from you!',
                ),
                const SizedBox(height: 32),
                _ContactCard(
                  title: 'Technical Support',
                  description:
                      'Having issues with the app? Our technical team is ready to help.',
                  icon: Icons.computer_outlined,
                  actions: [
                    _ContactAction(
                      icon: Icons.email_outlined,
                      label: 'Email Support',
                      onTap: () => _launchEmail('support@tacticsacademy.com'),
                    ),
                    _ContactAction(
                      icon: FontAwesome.whatsapp_brand,
                      label: 'WhatsApp',
                      onTap: () => _launchWhatsApp('+919539004796'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _ContactCard(
                  title: 'General Inquiries',
                  description:
                      'Questions about our services or want to learn more?',
                  icon: Icons.info_outline,
                  actions: [
                    _ContactAction(
                      icon: Icons.email_outlined,
                      label: 'Email Us',
                      onTap: () => _launchEmail('siyadsiyad016@gmail.com'),
                    ),
                    _ContactAction(
                      icon: Icons.phone_outlined,
                      label: 'Call Us',
                      onTap: () => _launchPhone('+919539004796'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _ContactCard(
                  title: 'Business Development',
                  description:
                      'Interested in partnering with us or exploring business opportunities?',
                  icon: Icons.business_outlined,
                  actions: [
                    _ContactAction(
                      icon: Icons.email_outlined,
                      label: 'Business Email',
                      onTap: () => _launchEmail('siyadsiyad016@gmail.com'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const SizedBox(height: 32),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Back to App',
                      style: TextStyle(color: secondTextColour),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HeaderSection({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: secondTextColour,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<_ContactAction> actions;
  static const defaultTextColour = Color(0xFF2B2B2B);

  const _ContactCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: defaultTextColour, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: defaultTextColour,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: defaultTextColour,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: actions.map((action) => Expanded(child: action)).toList(),
          ),
        ],
      ),
    );
  }
}

class _ContactAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  static const defaultTextColour = Color(0xFF2B2B2B);

  const _ContactAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: defaultTextColour, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            color: defaultTextColour,
            fontSize: 14,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }
}

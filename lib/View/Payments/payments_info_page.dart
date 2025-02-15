import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentsInfoPage extends StatelessWidget {
  const PaymentsInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment System Info',
          style: secondaryTextTheme,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoSection(
                icon: Icons.payment_rounded,
                title: 'Payment System Overview',
                content:
                    'Our payment system integrates with Stripe to facilitate seamless transactions. The manager of the academy has the ability to enable or disable the payment system as needed.',
                delay: 0,
              ),
              _buildInfoSection(
                icon: Icons.calendar_month_rounded,
                title: 'Monthly Payment Requirement',
                content:
                    'If the payment system is enabled, students are required to pay a monthly fee set by the manager. Payments are processed securely through Stripe, ensuring a safe transaction experience.',
                delay: 200,
              ),
              _buildProcessSection(delay: 400),
              _buildInfoSection(
                icon: Icons.toggle_on_rounded,
                title: 'Enabling and Disabling Payments',
                content:
                    'Managers can toggle the payment system on or off as required. When disabled, students are not required to make monthly payments.',
                delay: 600,
              ),
              _buildInfoSection(
                icon: Icons.support_agent_rounded,
                title: 'Refund and Support',
                content:
                    'For refund requests or payment issues, students can contact the academy management. Refunds will be processed in accordance with Stripe policies.',
                delay: 800,
              ),
              _buildContactSupport(context, delay: 1000),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String content,
    required int delay,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backGroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: secondTextColour.withOpacity(0.1),
        ),
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: secondTextColour.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: secondTextColour,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: secondTextColour,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: TextStyle(
              color: secondTextColour.withOpacity(0.8),
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: const Duration(milliseconds: 600))
        .slideX(begin: 0.2, end: 0);
  }

  Widget _buildProcessSection({required int delay}) {
    final steps = [
      {
        'icon': Icons.toggle_on_rounded,
        'text': 'Manager enables payments and sets fee'
      },
      {
        'icon': Icons.payment_rounded,
        'text': 'Students complete monthly payments'
      },
      {'icon': Icons.security_rounded, 'text': 'Secure processing via Stripe'},
      {'icon': Icons.history_rounded, 'text': 'Payment history recorded'},
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backGroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: secondTextColour.withOpacity(0.1),
        ),
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
          const Row(
            children: [
              Icon(
                Icons.insights_rounded,
                color: secondTextColour,
                size: 24,
              ),
              SizedBox(width: 16),
              Text(
                'How Payments Work',
                style: TextStyle(
                  color: secondTextColour,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: secondTextColour.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: secondTextColour,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      step['text'].toString(),
                      style: TextStyle(
                        color: secondTextColour.withOpacity(0.8),
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Icon(
                    step['icon'] as IconData,
                    color: secondTextColour.withOpacity(0.6),
                    size: 20,
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: const Duration(milliseconds: 600))
        .slideX(begin: 0.2, end: 0);
  }

  Widget _buildContactSupport(BuildContext context, {required int delay}) {
    return Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: secondTextColour.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.help_outline_rounded,
              color: secondTextColour,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Need Help?',
                    style: TextStyle(
                      color: secondTextColour,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Contact support for payment-related questions',
                    style: TextStyle(
                      color: secondTextColour.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
                onPressed: () async {
                  final Uri emailUri = Uri(
                    scheme: 'mailto',
                    path: 'siyadsiyad016@gmail.com',
                    query:
                        'subject=Payment Support Request&body=Hello, I need assistance with regarding to payment...',
                  );
                  if (await canLaunchUrl(emailUri)) {
                    await launchUrl(emailUri);
                  }
                },
                child: const Text(
                  'Contact',
                  style: TextStyle(
                      color: secondTextColour, fontWeight: FontWeight.bold),
                ))
          ],
        ));
  }
}

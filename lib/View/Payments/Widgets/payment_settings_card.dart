import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tactix_academy_manager/Controller/Controllers/payment_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

import 'package:tactix_academy_manager/View/Payments/Widgets/payment_disabled_message.dart';
import 'package:tactix_academy_manager/View/Payments/Widgets/payment_input_session.dart';
import 'package:tactix_academy_manager/View/Payments/Widgets/payment_toggle_switch.dart';
import 'package:tactix_academy_manager/View/Payments/Widgets/payments_settings_header.dart';

class PaymentSettingsCard extends StatelessWidget {
  final PaymentProvider paymentProvider;

  const PaymentSettingsCard({
    super.key,
    required this.paymentProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            // color: mainTextColour.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Card(
        color: paymentProvider.isEnabled
            ? Colors.green.withOpacity(0.6)
            : mainTextColour2.withOpacity(0.6),
        elevation:
            0, // Removed default elevation since we're using custom shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // Increased border radius
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Decorative background elements
              Positioned(
                right: -50,
                top: -50,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Main content
              Padding(
                padding: const EdgeInsets.all(24), // Increased padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PaymentSettingsHeader(paymentProvider: paymentProvider)
                        .animate()
                        .fadeIn(duration: const Duration(milliseconds: 600))
                        .slideX(begin: -0.2, end: 0),
                    const SizedBox(height: 32), // Increased spacing
                    if (paymentProvider.isEnabled) ...[
                      PaymentInputSection(paymentProvider: paymentProvider)
                          .animate(delay: const Duration(milliseconds: 200))
                          .fadeIn(duration: const Duration(milliseconds: 600))
                          .slideX(begin: 0.2, end: 0),
                    ] else
                      const PaymentDisabledMessage()
                          .animate(delay: const Duration(milliseconds: 200))
                          .fadeIn(duration: const Duration(milliseconds: 600))
                          .slideX(begin: 0.2, end: 0),
                    const SizedBox(height: 32),
                    // Divider for visual separation
                    Divider(
                      color: Colors.white.withOpacity(0.1),
                      thickness: 1,
                    )
                        .animate(delay: const Duration(milliseconds: 400))
                        .fadeIn(duration: const Duration(milliseconds: 600)),
                    const SizedBox(height: 24),
                    PaymentToggleSwitch(paymentProvider: paymentProvider)
                        .animate(delay: const Duration(milliseconds: 600))
                        .fadeIn(duration: const Duration(milliseconds: 600))
                        .slideY(begin: 0.2, end: 0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 800))
        .slideY(begin: 0.3, end: 0);
  }
}

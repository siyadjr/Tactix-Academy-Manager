import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Payments/payments_info_page.dart';

class PaymentDisabledMessage extends StatelessWidget {
  const PaymentDisabledMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 32,
      ),
      decoration: BoxDecoration(
        color: backGroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: secondTextColour.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: secondTextColour.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              FontAwesome.note_sticky_solid,
              size: 32,
              color: secondTextColour,
            ),
          ).animate().fadeIn(duration: const Duration(milliseconds: 600)),
        ),
        const SizedBox(height: 24),
        const Text(
          'Payments are currently disabled',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: secondTextColour,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        )
            .animate(delay: const Duration(milliseconds: 200))
            .fadeIn(duration: const Duration(milliseconds: 600))
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: 12),
        Text(
          'Toggle the switch below to enable payments',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: secondTextColour.withOpacity(0.8),
            fontSize: 15,
            height: 1.5,
            letterSpacing: -0.3,
          ),
        )
            .animate(delay: const Duration(milliseconds: 400))
            .fadeIn(duration: const Duration(milliseconds: 600))
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: 24),
        _buildActionButton(context),
      ]),
    ).animate().fadeIn(duration: const Duration(milliseconds: 800));
    // .scale(begin: 1, end: 1);
  }

  Widget _buildActionButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => PaymentsInfoPage()));
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: secondTextColour.withOpacity(0.2),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Learn more about payments',
                style: TextStyle(
                  color: secondTextColour.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: secondTextColour.withOpacity(0.9),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: const Duration(milliseconds: 600))
        .fadeIn(duration: const Duration(milliseconds: 600))
        .slideY(begin: 0.3, end: 0);
  }
}

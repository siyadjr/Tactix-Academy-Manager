import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/payment_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Payments/Widgets/payment_ammount_field.dart';
import 'package:tactix_academy_manager/View/Payments/Widgets/payment_save_button.dart';
import 'package:tactix_academy_manager/View/Payments/Widgets/payment_validation.dart';

class PaymentInputSection extends StatelessWidget {
  final PaymentProvider paymentProvider;

  const PaymentInputSection({
    super.key,
    required this.paymentProvider,
  });

  bool _isValidAmount(String value) {
    if (value.isEmpty) return false;
    
    // Check if the value contains any decimal points
    if (value.contains('.')) return false;
    
    // Try to parse the value to an integer
    try {
      final amount = int.parse(value);
      // Check if the amount is positive and greater than 0
      return amount > 0;
    } catch (e) {
      return false;
    }
  }

  String? _getValidationMessage(String value) {
    if (value.isEmpty) {
      return 'Please enter a payment amount';
    }
    if (value.contains('.')) {
      return 'Decimal numbers are not allowed';
    }
    if (value.contains('-')) {
      return 'Negative numbers are not allowed';
    }
    try {
      final amount = int.parse(value);
      if (amount <= 0) {
        return 'Amount must be greater than 0';
      }
    } catch (e) {
      return 'Please enter a valid number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backGroundColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: secondTextColour.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment Amount',
                style: TextStyle(
                  color: secondTextColour,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ).animate()
                .fadeIn(duration: const Duration(milliseconds: 600))
                .slideX(begin: -0.2, end: 0),
              IconButton(
                onPressed: () => _showLearnMoreDialog(context),
                icon: Icon(
                  Icons.help_outline_rounded,
                  color: secondTextColour.withOpacity(0.6),
                  size: 20,
                ),
                tooltip: 'Learn more about payments',
              ).animate()
                .fadeIn(duration: const Duration(milliseconds: 600))
                .slideX(begin: 0.2, end: 0),
            ],
          ),
          const SizedBox(height: 16),
          Consumer<PaymentProvider>(
            builder: (context, provider, child) {
              final isValid = _isValidAmount(provider.paymentController.text);
              final validationMessage = _getValidationMessage(provider.paymentController.text);
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PaymentAmountField(
                          paymentProvider: provider,
                          onChanged: (value) {
                            // Trigger a rebuild when the text changes
                            provider.notifyListeners();
                          },
                        ).animate(delay: const Duration(milliseconds: 200))
                          .fadeIn(duration: const Duration(milliseconds: 600))
                          .slideY(begin: 0.2, end: 0),
                      ),
                      const SizedBox(width: 12),
                      if (isValid) 
                        PaymentSaveButton(paymentProvider: provider)
                          .animate(delay: const Duration(milliseconds: 400))
                          .fadeIn(duration: const Duration(milliseconds: 600))
                          .slideY(begin: 0.2, end: 0),
                    ],
                  ),
                  if (validationMessage != null) ...[
                    const SizedBox(height: 16),
                    PaymentValidationMessage(message: validationMessage)
                      .animate(delay: const Duration(milliseconds: 600))
                      .fadeIn(duration: const Duration(milliseconds: 600))
                      .slideY(begin: 0.2, end: 0),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          _buildQuickTip(),
        ],
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 800));
  }

  void _showLearnMoreDialog(BuildContext context) {
    // ... (keeping existing dialog code)
  }


}

  Widget _buildQuickTip() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: secondTextColour.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: secondTextColour.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 20,
            color: secondTextColour.withOpacity(0.7),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Quick Tip: You can modify this amount for individual registrations later.',
              style: TextStyle(
                  color: secondTextColour.withOpacity(0.7),
                  fontSize: 13,
                  height: 1.4,
                  overflow: TextOverflow.fade),
            ),
          ),
        ],
      ),
    )
        .animate(delay: const Duration(milliseconds: 800))
        .fadeIn(duration: const Duration(milliseconds: 600))
        .slideY(begin: 0.2, end: 0);
  }

  void _showLearnMoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: backGroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 48,
                color: secondTextColour.withOpacity(0.9),
              ),
              const SizedBox(height: 16),
              const Text(
                'About Payments',
                style: TextStyle(
                  color: secondTextColour,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Set the default payment amount for your academy. This amount will be applied to all new registrations unless modified.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondTextColour.withOpacity(0.8),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ],
          )),
    );
  }

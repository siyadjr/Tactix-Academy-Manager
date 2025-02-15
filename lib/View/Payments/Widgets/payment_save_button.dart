import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Controller/Controllers/payment_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

class PaymentSaveButton extends StatelessWidget {
  final PaymentProvider paymentProvider;

  const PaymentSaveButton({
    super.key,
    required this.paymentProvider,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: paymentProvider.paymentController.text.isEmpty
          ? null
          : () => paymentProvider.updatePaymentFee(),
      style: ElevatedButton.styleFrom(
        backgroundColor: backGroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: const Icon(Icons.save, color: secondTextColour),
      label: const Text(
        'Save',
        style: TextStyle(color: secondTextColour),
      ),
    );
  }
}



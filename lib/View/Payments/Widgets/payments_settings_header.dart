import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Controller/Controllers/payment_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Payments/Widgets/payment_status_chip.dart';

class PaymentSettingsHeader extends StatelessWidget {
  final PaymentProvider paymentProvider;

  const PaymentSettingsHeader({
    super.key,
    required this.paymentProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Payment Settings',
          style: TextStyle(
            color: secondTextColour,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        PaymentStatusChip(isEnabled: paymentProvider.isEnabled),
      ],
    );
  }
}




import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

class PaymentStatusChip extends StatelessWidget {
  final bool isEnabled;

  const PaymentStatusChip({
    super.key,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isEnabled ? Colors.green : mainTextColour2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isEnabled ? 'Active' : 'Inactive',
        style: const TextStyle(
          color: secondTextColour,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
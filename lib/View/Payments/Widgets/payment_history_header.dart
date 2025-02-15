import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

class PaymentHistoryHeader extends StatelessWidget {
  final String monthName;

  const PaymentHistoryHeader({
    super.key,
    required this.monthName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.calendar_month, color: mainTextColour),
        const SizedBox(width: 8),
        Text(
          '$monthName Payment History',
          style: const TextStyle(
            color: mainTextColour,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class PaymentHistoryEmptyState extends StatelessWidget {
  const PaymentHistoryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      alignment: Alignment.center,
      child: const Column(
        children: [
          Icon(
            Icons.history,
            size: 48,
            color: mainTextColour,
          ),
          SizedBox(height: 16),
          Text(
            'No payment history yet',
            style: TextStyle(
              fontSize: 16,
              color: mainTextColour,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}



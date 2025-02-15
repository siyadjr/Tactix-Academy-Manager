import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Payments/payment_statistics.dart';

class PaymentHistoryViewAllButton extends StatelessWidget {
  const PaymentHistoryViewAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (ctx) => const PaymentStatistics()));
        },
        icon:
            const Icon(Icons.stacked_line_chart_rounded, color: mainTextColour),
        label: const Text(
          'View All Payment Details',
          style: TextStyle(color: mainTextColour),
        ),
      ),
    );
  }
}

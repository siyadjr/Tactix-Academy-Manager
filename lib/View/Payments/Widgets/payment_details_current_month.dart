import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/payments_details_provider.dart';
import 'package:tactix_academy_manager/View/Payments/Widgets/payment_statistics_payment_list.dart';
import 'package:tactix_academy_manager/View/Payments/Widgets/payment_statistics_progress_card.dart';

class CurrentMonthView extends StatelessWidget {
  final PaymentsDetailsProvider provider;

  const CurrentMonthView({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentsDetailsProvider>(
      builder: (context, paymentProvider, child) =>
          paymentProvider.thisMonthRent
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ProgressCard(provider: provider),
                      const SizedBox(height: 20),
                      PaymentLists(provider: provider),
                    ],
                  ),
                )
              : const NoFeeAssigned(),
    );
  }
}

class NoFeeAssigned extends StatelessWidget {
  const NoFeeAssigned({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.payment_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Fee Assigned This Month',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
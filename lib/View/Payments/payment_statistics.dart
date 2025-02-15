import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:tactix_academy_manager/Controller/Controllers/payments_details_provider.dart';
import 'package:tactix_academy_manager/Core/ReusableWidgets/loading_indicator.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Payments/Widgets/payment_details_current_month.dart';
import 'package:tactix_academy_manager/View/Payments/Widgets/payment_statistics_app_bar.dart';
import 'package:tactix_academy_manager/View/Payments/Widgets/payment_statistics_payment_history.dart';

class PaymentStatistics extends StatelessWidget {
  const PaymentStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: PaymentStatisticsBody(),
      ),
    );
  }
}

class PaymentStatisticsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentsDetailsProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => provider.getAllDetails());

    return Consumer<PaymentsDetailsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: LoadingIndicator());
        }
        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            PaymentStatisticsAppBar(),
          ],
          body: TabBarView(
            children: [
              CurrentMonthView(provider: provider),
              PaymentHistoryView(provider: provider),
            ],
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/payment_provider.dart';
import 'package:tactix_academy_manager/Core/ReusableWidgets/loading_indicator.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Payments/Widgets/payment_history_card.dart';
import 'package:tactix_academy_manager/View/Payments/Widgets/payment_settings_card.dart';

class Payments extends StatelessWidget {
  const Payments({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.checkIsPaymentEnabled();
      provider.getThisMonthPaidPlayers();
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backGroundColor,
        title: const Text('Fee Payments', style: secondaryTextTheme),
      ),
      body: Container(
        color: backGroundColor,
        child: Consumer<PaymentProvider>(
          builder: (context, paymentProvider, child) =>
              paymentProvider.isLoading
                  ? const Center(
                      child: LoadingIndicator(),
                    )
                  : PaymentBody(paymentProvider: paymentProvider),
        ),
      ),
    );
  }
}

class PaymentBody extends StatelessWidget {
  final PaymentProvider paymentProvider;

  const PaymentBody({
    super.key,
    required this.paymentProvider,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PaymentSettingsCard(paymentProvider: paymentProvider),
            const SizedBox(height: 24),
            PaymentHistoryCard(paymentProvider: paymentProvider),
          ],
        ),
      ),
    );
  }
}

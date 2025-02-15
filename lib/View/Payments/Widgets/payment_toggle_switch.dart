import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Controller/Controllers/payment_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

class PaymentToggleSwitch extends StatelessWidget {
  final PaymentProvider paymentProvider;

  const PaymentToggleSwitch({
    super.key,
    required this.paymentProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: backGroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Status',
                style: TextStyle(
                  color: secondTextColour,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                paymentProvider.isEnabled ? 'Enabled' : 'Disabled',
                style: TextStyle(
                  color: secondTextColour.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Switch.adaptive(
            value: paymentProvider.isEnabled,
            onChanged: (value) {
              paymentProvider.changeSwitch();
              paymentProvider.changeStatus();
            },
            activeColor: Colors.green,
            inactiveThumbColor: mainTextColour2,
          ),
        ],
      ),
    );
  }
}

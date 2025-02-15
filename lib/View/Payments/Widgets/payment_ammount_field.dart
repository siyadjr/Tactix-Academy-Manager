import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Controller/Controllers/payment_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

class PaymentAmountField extends StatelessWidget {
  final PaymentProvider paymentProvider;

  const PaymentAmountField({
    super.key,
    required this.paymentProvider,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: paymentProvider.paymentController,
      onChanged: (value) => paymentProvider.notifyListeners(),
      style: const TextStyle(color: secondTextColour),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: backGroundColor,
        prefixIcon: const Icon(
          Icons.currency_rupee,
          color: secondTextColour,
        ),
        hintText: 'Enter amount',
        hintStyle: TextStyle(color: secondTextColour.withOpacity(0.6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: iconColour, width: 2),
        ),
      ),
    );
  }
}

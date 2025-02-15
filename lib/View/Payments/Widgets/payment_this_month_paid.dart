import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Controller/Controllers/payment_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

class PaymentPaidThisMonth extends StatelessWidget {
  const PaymentPaidThisMonth({
    super.key,
    required this.paymentProvider,
  });

  final PaymentProvider paymentProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: paymentProvider.thisMontPaidPlayers.length,
      separatorBuilder: (context, index) =>
          const Divider(color: mainTextColour),
      itemBuilder: (context, index) {
        final player = paymentProvider.thisMontPaidPlayers[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: mainTextColour.withOpacity(0.1),
            child: ClipOval(
              child: Image.network(
                player.userProfile,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.person,
                  color: mainTextColour,
                ),
              ),
            ),
          ),
          title: Text(
            player.name,
            style: const TextStyle(
              color: secondTextColour,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}

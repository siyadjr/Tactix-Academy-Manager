import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:tactix_academy_manager/Controller/Controllers/payment_specific_controller.dart';
import 'package:tactix_academy_manager/Core/ReusableWidgets/loading_indicator.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Payments/Widgets/payment_section_header.dart';
import 'package:tactix_academy_manager/View/Payments/Widgets/payment_unpaid_players.dart';

class PaymentSpecificDetails extends StatelessWidget {
  final String id;
  const PaymentSpecificDetails({super.key, required this.id});

  // Format date from ISO string to readable format
  String formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<PaymentSpecificController>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getSpecificPaymentDetails(id);
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Payment Details",
          style: secondaryTextTheme,
        ),
      ),
      body: Consumer<PaymentSpecificController>(
        builder: (context, provider, child) {
          if (provider.fetchedPlayerPayments.isEmpty &&
              provider.unpaidPlayers.isEmpty) {
            return const Center(child: LoadingIndicator());
          }
          return provider.isLoading
              ? const Center(child: LoadingIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (provider.fetchedPlayerPayments.isNotEmpty) ...[
                      const SectionHeader(
                        title: "Paid Players",
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 12),
                      ...provider.fetchedPlayerPayments.map((payment) {
                        return Card(
                          color: mainTextColour,
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue.shade50,
                                      backgroundImage: NetworkImage(
                                          payment.player.userProfile),
                                      onBackgroundImageError: (_,
                                          __) {}, // Prevents errors but doesn't replace the image
                                      child: payment.player.userProfile.isEmpty
                                          ? const Icon(Icons.person,
                                              color: Colors
                                                  .blueGrey) // Default icon when no image
                                          : null, // Ensures the image is displayed
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            payment.player.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            formatDate(payment.paidDate),
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "₹${payment.amount}", // Use ₹ instead of $
                                        style: TextStyle(
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                    if (provider.unpaidPlayers.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const SectionHeader(
                        title: "Pending Payments",
                        icon: Icons.warning_rounded,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 12),
                      PaymentUnpaidPlayers(
                          unpaidPlayers: provider.unpaidPlayers),
                    ],
                  ],
                );
        },
      ),
    );
  }
}

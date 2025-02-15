import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tactix_academy_manager/Controller/Controllers/payment_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Payments/Widgets/payment_history_button.dart';
import 'package:tactix_academy_manager/View/Payments/Widgets/payment_history_header.dart';
import 'package:tactix_academy_manager/View/Payments/Widgets/payment_this_month_paid.dart';

class PaymentHistoryCard extends StatelessWidget {
  final PaymentProvider paymentProvider;

  const PaymentHistoryCard({super.key, required this.paymentProvider});

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateTime.now().month;
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            mainTextColour.withOpacity(0.08),
            mainTextColour2.withOpacity(0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: mainTextColour.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: mainTextColour.withOpacity(0.15),
              width: 1.2,
            ),
          ),
          child: Column(
            children: [
              // Header with improved contrast
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      mainTextColour.withOpacity(0.15),
                      mainTextColour2.withOpacity(0.1),
                    ],
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: PaymentHistoryHeader(monthName: months[currentMonth - 1])
                    .animate()
                    .fadeIn(duration: const Duration(milliseconds: 600))
                    .slideX(begin: -0.2, end: 0),
              ),

              // Main content
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    if (paymentProvider.thisMontPaidPlayers.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              secondTextColour.withOpacity(0.1),
                              secondTextColour.withOpacity(0.07),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const PaymentHistoryEmptyState(),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              secondTextColour.withOpacity(0.1),
                              secondTextColour.withOpacity(0.07),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: PaymentPaidThisMonth(
                            paymentProvider: paymentProvider),
                      ),

                    const SizedBox(height: 24),

                    // View All button with better colors
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            mainTextColour.withOpacity(0.15),
                            mainTextColour2.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const PaymentHistoryViewAllButton(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 800))
        .slideY(begin: 0.3, end: 0);
  }
}

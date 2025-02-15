

import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Controller/Controllers/payments_details_provider.dart';

class ProgressCard extends StatelessWidget {
  final PaymentsDetailsProvider provider;

  const ProgressCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final totalPlayers = provider.thisMonthPaidPlayers.length +
        provider.thisMonthUnpaidPlayers.length;
    final paidPercentage = totalPlayers > 0
        ? (provider.thisMonthPaidPlayers.length / totalPlayers) * 100
        : 0.0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatCard(
                  title: 'Total Paid',
                  value: provider.thisMonthPaidPlayers.length.toString(),
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
                StatCard(
                  title: 'Pending',
                  value: provider.thisMonthUnpaidPlayers.length.toString(),
                  icon: Icons.warning,
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${paidPercentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Collection Rate',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({super.key, 
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

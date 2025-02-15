import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tactix_academy_manager/Controller/Controllers/payments_details_provider.dart';
import 'package:tactix_academy_manager/View/Payments/payment_specific_details.dart';

class PaymentHistoryView extends StatelessWidget {
  final PaymentsDetailsProvider provider;

  const PaymentHistoryView({super.key, required this.provider});
  
  @override
  Widget build(BuildContext context) {
    return provider.allPayments.isEmpty
        ? const Center(
            child: Text('No data available'),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.allPayments.length,
            itemBuilder: (context, index) {
              final payment = provider.allPayments[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: Colors.black87,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    formatMonthYear(payment.name),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.white),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) =>
                                PaymentSpecificDetails(id: payment.name)));
                  },
                ),
              );
            },
          );
  }

  String formatMonthYear(String monthYear) {
    List<String> parts = monthYear.split('-');
    if (parts.length != 2) return monthYear;

    int month = int.parse(parts[0]);
    int year = int.parse(parts[1]);

    DateTime date = DateTime(year, month);
    return DateFormat('MMMM yyyy').format(date);
  }
}

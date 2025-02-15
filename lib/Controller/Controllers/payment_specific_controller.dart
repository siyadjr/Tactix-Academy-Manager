import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/payment_db.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/players_database.dart';
import 'package:tactix_academy_manager/Model/Models/payment_model.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';

class PaymentSpecificController extends ChangeNotifier {
  List<PaymentModel> fetchedPlayerPayments = [];
  List<PlayerModel> unpaidPlayers = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<void> getSpecificPaymentDetails(String id) async {
    _isLoading = true;
    notifyListeners();
    fetchedPlayerPayments.clear();
    unpaidPlayers.clear();

    final paymentPlayers = await PaymentDb().getPaymentDetails(id);
    final allPlayers = await PlayerDatabase().getAllPlayers();

    fetchedPlayerPayments.addAll(paymentPlayers);

    // Extract all paid player IDs
    Set<String> paidPlayerIds =
        paymentPlayers.map((payment) => payment.payerId).toSet();

    // Find unpaid players
    unpaidPlayers = allPlayers
        .where((player) => !paidPlayerIds.contains(player.id))
        .toList();
    _isLoading = false;
    notifyListeners();
  }
}

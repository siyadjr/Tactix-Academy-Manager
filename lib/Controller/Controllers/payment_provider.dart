import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/payment_db.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/players_database.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/team_database.dart';
import 'package:tactix_academy_manager/Model/Models/payment_model.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';

class PaymentProvider extends ChangeNotifier {
  bool _isEnabled = false;
  bool get isEnabled => _isEnabled;
  List<PaymentModel> _payments = [];
  List<PlayerModel> _thisMonthPaidPlayers = [];
  List<PlayerModel> get thisMontPaidPlayers => _thisMonthPaidPlayers;
  TextEditingController _paymentController = TextEditingController();
  TextEditingController get paymentController => _paymentController;
  List<PaymentModel> get payments => _payments;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void changeSwitch() {
    _isEnabled = !_isEnabled;
    notifyListeners();
  }

  Future<void> checkIsPaymentEnabled() async {
    _thisMonthPaidPlayers = [];
    _isLoading = true;
    notifyListeners();
    try {
      bool check = await TeamDatabase().getRentPaymentEnabled();
      if (check == true) {
        checkPaymentFee();
      }
      _isEnabled = check;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getThisMonthPaidPlayers() async {
    _isLoading = true;
    _thisMonthPaidPlayers = [];
    notifyListeners();
    try {
      final players = await PaymentDb().getThisMonthPaidPlayers();
      _payments = players;
      for (var payerId in _payments) {
        final player = await PlayerDatabase().getPlayerDetails(payerId.payerId);
        if (player != null) _thisMonthPaidPlayers.add(player);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      log('Error fetching paid players: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changeStatus() async {
    if (_isEnabled == false) {
      TeamDatabase().disablePayment();
      _paymentController.clear();
    } else {
      TeamDatabase().enablePayment();
      checkPaymentFee();
    }
  }

  Future<void> updatePaymentFee() async {
    _isLoading = true;
    notifyListeners();

    await TeamDatabase().updateRentFee(_paymentController.text);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkPaymentFee() async {
    String fee = await TeamDatabase().getPaymentFee();
    _paymentController.text = fee;
    notifyListeners();
  }

  @override
  void dispose() {
    _paymentController.dispose();
    super.dispose();
  }
}

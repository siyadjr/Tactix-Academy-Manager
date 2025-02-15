import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/payment_db.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/players_database.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/team_database.dart';
import 'package:tactix_academy_manager/Model/Models/payment_category_model.dart';
import 'package:tactix_academy_manager/Model/Models/payment_model.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';

class PaymentsDetailsProvider extends ChangeNotifier {
  List<PaymentModel> _payments = [];
  List<PlayerModel> _thisMonthPaidPlayers = [];
  List<PlayerModel> _thisMonthUnpaidPlayers = [];
  List<PaymentCategoryModel> allPayments = [];
  String _searchQuery = '';
  DateTime _selectedMonth = DateTime.now();
  bool _thisMonthRent = false;
  bool get thisMonthRent => _thisMonthRent;
  bool _isLoading = false;

  List<PlayerModel> get thisMonthPaidPlayers => _thisMonthPaidPlayers;

  List<PlayerModel> get thisMonthUnpaidPlayers => _thisMonthUnpaidPlayers;

  List<PaymentModel> get payments => _payments;
  bool get isLoading => _isLoading;
  DateTime get selectedMonth => _selectedMonth;


  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedMonth(DateTime month) {
    _selectedMonth = month;
    getAllDetails();
  }

  Future<void> getAllDetails() async {
    _isLoading = true;
    notifyListeners();

    try {
      _thisMonthPaidPlayers.clear();
      _thisMonthUnpaidPlayers.clear();
      allPayments.clear();
      final paidPlayers = await PaymentDb().getThisMonthPaidPlayers();
      final allPlayers = await PlayerDatabase().getAllPlayers();
      final allPaymentsFetch = await PaymentDb().getAllPayments();
      allPayments = allPaymentsFetch;
      _payments = paidPlayers;
      _thisMonthRent = await TeamDatabase().getRentPaymentEnabled();
      if (_thisMonthRent) {
        for (var player in allPlayers) {
          if (paidPlayers.any((payment) => payment.payerId == player.id)) {
            _thisMonthPaidPlayers.add(player);
          } else {
            _thisMonthUnpaidPlayers.add(player);
          }
        }
      }
    } catch (e) {
      log('Error fetching payment details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}

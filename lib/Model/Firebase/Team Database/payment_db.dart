import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/players_database.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/team_database.dart';
import 'package:tactix_academy_manager/Model/Models/payment_category_model.dart';
import 'package:tactix_academy_manager/Model/Models/payment_model.dart';

class PaymentDb {
  /// Checks if the rent for the current month is active
  Future<bool> thisMonthRentActive() async {
    try {
      final teamId = await TeamDatabase().getTeamId();
      if (teamId == null) return false;

      final now = DateTime.now();
      final todaysMonthAndYear = '${now.month}-${now.year}';

      final snapShot = await FirebaseFirestore.instance
          .collection('Teams')
          .doc(teamId)
          .collection('Payments')
          .doc(todaysMonthAndYear)
          .get();

      return snapShot.exists;
    } catch (e) {
      log('Error checking rent status: $e');
      return false;
    }
  }

  /// Retrieves the list of players who have paid for the current month
  Future<List<PaymentModel>> getThisMonthPaidPlayers() async {
    try {
      final teamId = await TeamDatabase().getTeamId();
      if (teamId == null) return [];

      final now = DateTime.now();
      final todaysMonthAndYear = '${now.month}-${now.year}';

      final snapShot = await FirebaseFirestore.instance
          .collection('Teams')
          .doc(teamId)
          .collection('Payments')
          .doc(todaysMonthAndYear)
          .collection('PaidPlayers')
          .get();

      // Fetch player details in parallel
      final paymentModels = await Future.wait(snapShot.docs.map((doc) async {
        final data = doc.data();
        final player = await PlayerDatabase()
            .getPlayerDetails(data['userId']); // Await inside async function
        return PaymentModel(
          id: doc.id,
          amount: data['amount'].toString(),
          player: player,
          paidDate: data['paidDate'],
          payerId: data['userId'],
        );
      }).toList());

      return paymentModels;
    } catch (e) {
      log('Error fetching paid players: $e');
      return [];
    }
  }

  /// Retrieves all payment records for the team
  Future<List<PaymentCategoryModel>> getAllPayments() async {
    try {
      final teamId = await TeamDatabase().getTeamId();
      if (teamId == null) return [];

      final snapShot = await FirebaseFirestore.instance
          .collection('Teams')
          .doc(teamId)
          .collection('Payments')
          .get();

      List<PaymentCategoryModel> allPayments = [];

      for (var doc in snapShot.docs) {
        final data = doc.data();
        if (data != null) {
          final payment = PaymentCategoryModel(name: doc.id);
          allPayments.add(payment);
        }
      }

      return allPayments;
    } catch (e) {
      log('Error fetching all payments: $e');
      return [];
    }
  }

  Future<List<PaymentModel>> getPaymentDetails(String id) async {
    try {
      final teamID = await TeamDatabase().getTeamId();
      if (teamID == null) return [];

      final snapshot = await FirebaseFirestore.instance
          .collection('Teams')
          .doc(teamID)
          .collection('Payments')
          .doc(id)
          .collection('PaidPlayers')
          .get();

      // Fetch player details in parallel
      final paymentPlayers = await Future.wait(snapshot.docs.map((doc) async {
        final data = doc.data();
        final player = await PlayerDatabase()
            .getPlayerDetails(data['userId']); // Fetch player details
        return PaymentModel(
          id: doc.id,
          amount: data['amount'].toString(),
          player: player,
          paidDate: data['paidDate'],
          payerId: data['userId'],
        );
      }).toList());

      return paymentPlayers;
    } catch (e) {
      log('Error fetching payment details: $e');
      return [];
    }
  }
}

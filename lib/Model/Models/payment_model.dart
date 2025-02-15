import 'package:tactix_academy_manager/Model/Models/player_model.dart';

class PaymentModel {
  final String id;
  final String amount;
  final PlayerModel player;
  final String paidDate;
  final String payerId;

  PaymentModel({
    required this.id,
    required this.amount,
    required this.player,
    required this.paidDate,
    required this.payerId,
  });
}

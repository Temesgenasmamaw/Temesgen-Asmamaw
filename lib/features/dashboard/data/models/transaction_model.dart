import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  final String id;
  final String type;
  final String recipientName;
  final double amount;
  final DateTime date;
  final bool isCredit;

  const TransactionModel({
    this.id = '',
    this.type = '',
    this.recipientName = '',
    this.amount = 0.0,
    required this.date,
    this.isCredit = false,
  });

  @override
  List<Object?> get props => [id, type, recipientName, amount, date, isCredit];
}

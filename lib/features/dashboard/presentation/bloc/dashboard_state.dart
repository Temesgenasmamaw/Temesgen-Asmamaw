import 'package:equatable/equatable.dart';

import '../../data/models/transaction_model.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final double balance;
  final List<TransactionModel> transactions;
  final String? message;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.balance = 0.0,
    this.transactions = const [],
    this.message,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    double? balance,
    List<TransactionModel>? transactions,
    String? message,
  }) {
    return DashboardState(
      status: status ?? this.status,
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, balance, transactions, message];
}

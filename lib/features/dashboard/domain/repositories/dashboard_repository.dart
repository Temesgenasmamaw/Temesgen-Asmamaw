import '../../data/models/transaction_model.dart';

abstract class DashboardRepository {
  Future<double> getBalance();
  Future<List<TransactionModel>> getRecentTransactions();
}

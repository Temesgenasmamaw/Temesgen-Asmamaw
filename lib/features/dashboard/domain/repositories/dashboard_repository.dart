import '../../data/models/transaction_model.dart';

/// Abstract repository contract for dashboard operations.
abstract class DashboardRepository {
  Future<double> getBalance();
  Future<List<TransactionModel>> getRecentTransactions();
}

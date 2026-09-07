import '../models/transaction_model.dart';

/// Abstract contract for dashboard remote data operations.
abstract class DashboardRemoteDataSource {
  Future<double> getBalance();
  Future<List<TransactionModel>> getRecentTransactions();
}

/// Mock implementation with sample data.
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  @override
  Future<double> getBalance() async {
    await Future.delayed(const Duration(seconds: 1));
    return 45750.50;
  }

  @override
  Future<List<TransactionModel>> getRecentTransactions() async {
    await Future.delayed(const Duration(seconds: 1));
    final now = DateTime.now();
    return [
      TransactionModel(
        id: 'tx_001',
        type: 'Received',
        recipientName: 'Jane Wanjiku',
        amount: 5000,
        date: now.subtract(const Duration(hours: 2)),
        isCredit: true,
      ),
      TransactionModel(
        id: 'tx_002',
        type: 'Sent',
        recipientName: 'Peter Ochieng',
        amount: 1500,
        date: now.subtract(const Duration(hours: 5)),
        isCredit: false,
      ),
      TransactionModel(
        id: 'tx_003',
        type: 'Pay Bill',
        recipientName: 'KPLC Prepaid',
        amount: 2000,
        date: now.subtract(const Duration(days: 1)),
        isCredit: false,
      ),
      TransactionModel(
        id: 'tx_004',
        type: 'Received',
        recipientName: 'Mary Akinyi',
        amount: 10000,
        date: now.subtract(const Duration(days: 1, hours: 6)),
        isCredit: true,
      ),
      TransactionModel(
        id: 'tx_005',
        type: 'Buy Airtime',
        recipientName: 'Self',
        amount: 100,
        date: now.subtract(const Duration(days: 2)),
        isCredit: false,
      ),
    ];
  }
}

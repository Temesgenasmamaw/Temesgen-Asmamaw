import '../../../../core/errors/error_handler.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../models/transaction_model.dart';

/// Concrete implementation of [DashboardRepository].
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<double> getBalance() async {
    try {
      return await remoteDataSource.getBalance();
    } catch (e) {
      throw ErrorHandler.handle(e, 'Failed to load balance.');
    }
  }

  @override
  Future<List<TransactionModel>> getRecentTransactions() async {
    try {
      return await remoteDataSource.getRecentTransactions();
    } catch (e) {
      throw ErrorHandler.handle(e, 'Failed to load transactions.');
    }
  }
}

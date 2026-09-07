import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/repositories/dashboard_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository dashboardRepository;

  DashboardBloc({required this.dashboardRepository})
    : super(const DashboardState()) {
    on<DashboardLoaded>(_onLoaded);
    on<DashboardRefreshed>(_onRefreshed);
  }

  Future<void> _onLoaded(
    DashboardLoaded event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));

    try {
      final balance = await dashboardRepository.getBalance();
      final transactions = await dashboardRepository.getRecentTransactions();

      emit(
        state.copyWith(
          status: DashboardStatus.success,
          balance: balance,
          transactions: transactions,
        ),
      );
    } on AppException catch (e) {
      emit(state.copyWith(status: DashboardStatus.failure, message: e.message));
    }
  }

  Future<void> _onRefreshed(
    DashboardRefreshed event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final balance = await dashboardRepository.getBalance();
      final transactions = await dashboardRepository.getRecentTransactions();

      emit(
        state.copyWith(
          status: DashboardStatus.success,
          balance: balance,
          transactions: transactions,
        ),
      );
    } on AppException catch (e) {
      emit(state.copyWith(status: DashboardStatus.failure, message: e.message));
    }
  }
}

import 'package:equatable/equatable.dart';

/// Events for [DashboardBloc].
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Load dashboard data (balance + transactions).
class DashboardLoaded extends DashboardEvent {
  const DashboardLoaded();
}

/// Refresh dashboard data (pull-to-refresh).
class DashboardRefreshed extends DashboardEvent {
  const DashboardRefreshed();
}

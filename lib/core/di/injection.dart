import 'package:get_it/get_it.dart';

import '../networks/http_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';

/// Global service locator instance.
final getIt = GetIt.instance;

/// Configure all dependencies using manual registration
/// following the same lifecycle rules as @injectable annotations.
void configureDependencies() {
  // ── Core Services (Singleton) ──
  getIt.registerLazySingleton<HttpService>(() => HttpService());

  // ── Auth Feature ──
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(httpService: getIt<HttpService>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()),
  );
  // Factory: each screen gets a fresh BLoC instance.
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: getIt<AuthRepository>()),
  );

  // ── Dashboard Feature ──
  getIt.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: getIt<DashboardRemoteDataSource>(),
    ),
  );
  getIt.registerFactory<DashboardBloc>(
    () => DashboardBloc(dashboardRepository: getIt<DashboardRepository>()),
  );
}

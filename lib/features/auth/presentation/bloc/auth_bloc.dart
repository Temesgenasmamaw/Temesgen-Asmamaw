import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC managing authentication state.
///
/// Lean implementation with a single [AuthStatus] enum — no separate
/// mutation states for create/update/delete.
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthState()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthResetRequested>(_onResetRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final loginResponse = await authRepository.login(event.payload);
      final user = loginResponse.data?.user;

      if (loginResponse.success && user != null) {
        emit(state.copyWith(
          status: AuthStatus.success,
          user: user,
          message: loginResponse.message.isNotEmpty
              ? loginResponse.message
              : 'Login successful',
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.failure,
          message: loginResponse.message.isNotEmpty
              ? loginResponse.message
              : 'Authentication failed',
        ));
      }
    } on AppException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        message: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        message: 'An unexpected error occurred.',
      ));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      await authRepository.logout();
      emit(const AuthState());
    } on AppException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        message: e.message,
      ));
    }
  }

  void _onResetRequested(
    AuthResetRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      status: AuthStatus.initial,
      message: null,
    ));
  }
}

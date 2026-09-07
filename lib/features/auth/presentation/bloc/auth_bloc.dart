import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC managing authentication state.
///
/// Lean implementation with a single [AuthStatus] enum — no separate
/// mutation states for create/update/delete.
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
      final user = await authRepository.login(
        event.phoneNumber,
        event.pin,
      );
      emit(state.copyWith(
        status: AuthStatus.success,
        user: user,
        message: 'Welcome back, ${user.fullName}!',
      ));
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

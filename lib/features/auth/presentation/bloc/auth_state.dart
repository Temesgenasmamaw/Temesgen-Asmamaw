import 'package:equatable/equatable.dart';

import '../../data/models/user_model.dart';

/// Unified status enum — single 4-state CRUD per feature.
enum AuthStatus { initial, loading, success, failure }

/// State for the [AuthBloc].
class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String? message;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.message,
  });

  /// Convenience copyWith for immutable state updates.
  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, user, message];
}

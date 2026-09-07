import 'package:equatable/equatable.dart';

import '../../data/models/login_request_model.dart';

/// Events for the [AuthBloc].
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// User requested login with [LoginRequestModel] payload.
class AuthLoginRequested extends AuthEvent {
  final LoginRequestModel payload;

  const AuthLoginRequested({required this.payload});

  AuthLoginRequested.withPin(String pin) : payload = LoginRequestModel(pin: pin);

  @override
  List<Object?> get props => [payload];
}

/// User requested logout.
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Reset auth state (e.g. clear error messages).
class AuthResetRequested extends AuthEvent {
  const AuthResetRequested();
}

import 'package:equatable/equatable.dart';

import '../../data/models/login_request_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final LoginRequestModel payload;

  const AuthLoginRequested({required this.payload});

  AuthLoginRequested.withPin(String pin)
    : payload = LoginRequestModel(pin: pin);

  @override
  List<Object?> get props => [payload];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthResetRequested extends AuthEvent {
  const AuthResetRequested();
}

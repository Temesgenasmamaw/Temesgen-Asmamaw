import 'package:equatable/equatable.dart';

/// Events for the [AuthBloc].
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// User requested login with phone number.
/// Only the phone is submitted on login page; PIN is entered on pin page.
class AuthLoginRequested extends AuthEvent {
  final String phoneNumber;
  final String pin;

  const AuthLoginRequested({
    required this.phoneNumber,
    required this.pin,
  });

  @override
  List<Object?> get props => [phoneNumber, pin];
}

/// User requested logout.
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Reset auth state (e.g. clear error messages).
class AuthResetRequested extends AuthEvent {
  const AuthResetRequested();
}

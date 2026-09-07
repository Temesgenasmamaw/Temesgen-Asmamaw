import 'package:equatable/equatable.dart';

import '../../data/models/user_model.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String? message;

  const AuthState({this.status = AuthStatus.initial, this.user, this.message});

  AuthState copyWith({AuthStatus? status, UserModel? user, String? message}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, user, message];
}

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'user_model.dart';

part 'login_response_model.g.dart';

/// Full API response wrapper for the M-Pesa Login endpoint.
///
/// Successful response shape:
/// ```json
/// {
///   "success": true,
///   "message": "Login successful",
///   "data": {
///     "user": { ... },
///     "token": "mock_access_token_123456",
///     "expiresIn": 3600
///   }
/// }
/// ```
///
/// Error response shape:
/// ```json
/// {
///   "success": false,
///   "message": "User not found",
///   "error": {
///     "code": "USER_NOT_FOUND",
///     "details": "No user was found with the provided phone number."
///   }
/// }
/// ```
@JsonSerializable(explicitToJson: true)
class LoginResponseModel extends Equatable {
  final bool success;
  final String message;
  final LoginResponseData? data;
  final LoginResponseError? error;

  const LoginResponseModel({
    this.success = false,
    this.message = '',
    this.data,
    this.error,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);

  @override
  List<Object?> get props => [success, message, data, error];
}

/// Nested `data` object containing user, token, and expiry.
@JsonSerializable(explicitToJson: true)
class LoginResponseData extends Equatable {
  final UserModel user;
  final String token;
  final int expiresIn;

  const LoginResponseData({
    required this.user,
    required this.token,
    this.expiresIn = 3600,
  });

  factory LoginResponseData.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseDataToJson(this);

  @override
  List<Object?> get props => [user, token, expiresIn];
}

/// Nested `error` object returned on failed login.
@JsonSerializable()
class LoginResponseError extends Equatable {
  final String code;
  final String details;

  const LoginResponseError({
    this.code = '',
    this.details = '',
  });

  factory LoginResponseError.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseErrorFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseErrorToJson(this);

  @override
  List<Object?> get props => [code, details];
}

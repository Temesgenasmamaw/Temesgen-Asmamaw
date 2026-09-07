import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// User data transfer object matching the M-Pesa Login API response.
///
/// API response shape:
/// ```json
/// {
///   "id": "USR-10001",
///   "name": "John Doe",
///   "phoneNumber": "251911234567",
///   "email": "john.doe@example.com",
///   "balance": 1250.5,
///   "currency": "ETB"
/// }
/// ```
@JsonSerializable(explicitToJson: true)
class UserModel extends Equatable {
  final String id;

  /// Maps from API `name` field.
  @JsonKey(name: 'name')
  final String fullName;

  final String phoneNumber;
  final String? email;

  /// Maps from API `balance` field.
  @JsonKey(name: 'balance')
  final double accountBalance;

  final String? currency;

  const UserModel({
    this.id = '',
    this.fullName = '',
    this.phoneNumber = '',
    this.email,
    this.accountBalance = 0.0,
    this.currency,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        fullName,
        phoneNumber,
        email,
        accountBalance,
        currency,
      ];
}

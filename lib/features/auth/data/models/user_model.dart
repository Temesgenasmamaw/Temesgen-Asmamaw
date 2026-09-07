import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel extends Equatable {
  final String id;

  @JsonKey(name: 'name')
  final String fullName;

  final String phoneNumber;
  final String? email;

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

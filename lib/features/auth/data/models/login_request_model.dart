import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_request_model.g.dart';

/// Login request payload matching the M-Pesa Login API.
///
/// API expects: `{ "pin": "1111" }`
@JsonSerializable()
class LoginRequestModel extends Equatable {
  final String pin;

  const LoginRequestModel({this.pin = ''});

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);

  @override
  List<Object?> get props => [pin];
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponseModel _$LoginResponseModelFromJson(Map<String, dynamic> json) =>
    LoginResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] == null
          ? null
          : LoginResponseData.fromJson(json['data'] as Map<String, dynamic>),
      error: json['error'] == null
          ? null
          : LoginResponseError.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseModelToJson(LoginResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data?.toJson(),
      'error': instance.error?.toJson(),
    };

LoginResponseData _$LoginResponseDataFromJson(Map<String, dynamic> json) =>
    LoginResponseData(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String? ?? '',
      expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 3600,
    );

Map<String, dynamic> _$LoginResponseDataToJson(LoginResponseData instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'token': instance.token,
      'expiresIn': instance.expiresIn,
    };

LoginResponseError _$LoginResponseErrorFromJson(Map<String, dynamic> json) =>
    LoginResponseError(
      code: json['code'] as String? ?? '',
      details: json['details'] as String? ?? '',
    );

Map<String, dynamic> _$LoginResponseErrorToJson(LoginResponseError instance) =>
    <String, dynamic>{'code': instance.code, 'details': instance.details};

import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/networks/http_service.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

/// Abstract contract for remote authentication data operations.
abstract class AuthRemoteDataSource {
  /// Authenticate user with phone number and PIN.
  Future<UserModel> login(String phoneNumber, String pin);

  /// Log out the current user.
  Future<void> logout();
}

/// Implementation of [AuthRemoteDataSource] that connects to the M-Pesa Login API.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final HttpService httpService;

  AuthRemoteDataSourceImpl({required this.httpService});

  @override
  Future<UserModel> login(String phoneNumber, String pin) async {
    try {
      final response = await httpService.post(
        '/login',
        data: LoginRequestModel(pin: pin).toJson(),
      );

      final responseData = response.data;
      Map<String, dynamic> map;
      if (responseData is Map<String, dynamic>) {
        map = responseData;
      } else if (responseData is Map) {
        map = Map<String, dynamic>.from(responseData);
      } else if (responseData is String && responseData.isNotEmpty) {
        final decoded = jsonDecode(responseData);
        map = decoded is Map<String, dynamic>
            ? decoded
            : Map<String, dynamic>.from(decoded as Map);
      } else {
        map = {};
      }

      final loginResponse = LoginResponseModel.fromJson(map);

      if (loginResponse.success && loginResponse.data != null) {
        httpService.setAuthToken(loginResponse.data!.token);
        return loginResponse.data!.user;
      }

      final msg = loginResponse.message.isNotEmpty ? loginResponse.message : null;
      final details = loginResponse.error?.details.isNotEmpty == true
          ? loginResponse.error!.details
          : null;
      final errorMsg = (msg != null && details != null)
          ? '$msg: $details'
          : (msg ?? details ?? 'Authentication failed.');

      throw AppException(
        message: errorMsg,
        code: loginResponse.error?.code ?? 'AUTH_FAILED',
      );
    } on DioException catch (e) {
      if (e.response?.data != null) {
        try {
          final data = e.response!.data;
          Map<String, dynamic> map;
          if (data is Map<String, dynamic>) {
            map = data;
          } else if (data is Map) {
            map = Map<String, dynamic>.from(data);
          } else if (data is String && data.isNotEmpty) {
            final decoded = jsonDecode(data);
            map = decoded is Map<String, dynamic>
                ? decoded
                : Map<String, dynamic>.from(decoded as Map);
          } else {
            map = {};
          }

          final loginResponse = LoginResponseModel.fromJson(map);
          final msg = loginResponse.message.isNotEmpty ? loginResponse.message : null;
          final details = loginResponse.error?.details.isNotEmpty == true
              ? loginResponse.error!.details
              : null;
          final errorMsg = (msg != null && details != null)
              ? '$msg: $details'
              : (msg ?? details ?? 'Authentication failed.');

          throw ServerException(
            message: errorMsg,
            code: loginResponse.error?.code ?? 'AUTH_FAILED',
            statusCode: e.response?.statusCode,
          );
        } on AppException {
          rethrow;
        } catch (_) {
          rethrow;
        }
      }
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    httpService.clearAuthToken();
  }
}

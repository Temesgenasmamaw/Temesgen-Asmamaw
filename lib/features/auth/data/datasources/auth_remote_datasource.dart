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
      final map = responseData is Map<String, dynamic>
          ? responseData
          : Map<String, dynamic>.from(responseData as Map);
      final loginResponse = LoginResponseModel.fromJson(map);

      if (loginResponse.success && loginResponse.data != null) {
        httpService.setAuthToken(loginResponse.data!.token);
        return loginResponse.data!.user;
      }

      throw AppException(
        message: loginResponse.message.isNotEmpty
            ? loginResponse.message
            : 'Authentication failed.',
        code: loginResponse.error?.code ?? 'AUTH_FAILED',
      );
    } on DioException catch (e) {
      if (e.response?.data != null) {
        try {
          final data = e.response!.data;
          final map = data is Map<String, dynamic>
              ? data
              : Map<String, dynamic>.from(data as Map);
          final loginResponse = LoginResponseModel.fromJson(map);
          final details = loginResponse.error?.details;
          final errorMsg = (details != null && details.isNotEmpty)
              ? details
              : (loginResponse.message.isNotEmpty
                  ? loginResponse.message
                  : 'Invalid PIN. Please try again.');
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

import 'package:injectable/injectable.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/networks/http_service.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

/// Abstract contract for remote authentication data operations.
abstract class AuthRemoteDataSource {
  /// Authenticate user using [LoginRequestModel] payload.
  /// Returns [LoginResponseModel] representing the M-Pesa Login API response.
  Future<LoginResponseModel> login(LoginRequestModel payload);

  /// Log out the current user.
  Future<void> logout();
}

/// Implementation of [AuthRemoteDataSource] that connects to the M-Pesa Login API.
@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final HttpService httpService;

  AuthRemoteDataSourceImpl({required this.httpService});

  @override
  Future<LoginResponseModel> login(LoginRequestModel payload) async {
    final response = await httpService.post(
      '/login',
      data: payload.toJson(),
    );

    final loginResponse = LoginResponseModel.fromDynamic(response.data);

    if (loginResponse.success && loginResponse.data != null) {
      httpService.setAuthToken(loginResponse.data!.token);
      return loginResponse;
    }

    throw AppException(
      message: loginResponse.message.isNotEmpty
          ? loginResponse.message
          : 'Authentication failed.',
      code: loginResponse.error?.code ?? 'AUTH_FAILED',
    );
  }

  @override
  Future<void> logout() async {
    httpService.clearAuthToken();
  }
}


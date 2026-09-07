import '../../data/models/login_request_model.dart';
import '../../data/models/login_response_model.dart';

/// Abstract repository contract for authentication operations.
abstract class AuthRepository {
  /// Authenticate user with [LoginRequestModel] payload.
  /// Returns [LoginResponseModel] representing the API response.
  /// Throws [AppException] on failure.
  Future<LoginResponseModel> login(LoginRequestModel payload);

  /// Log out the current user.
  Future<void> logout();
}

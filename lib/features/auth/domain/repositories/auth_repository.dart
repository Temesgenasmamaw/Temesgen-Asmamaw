import '../../data/models/user_model.dart';

/// Abstract repository contract for authentication operations.
abstract class AuthRepository {
  /// Authenticate user with phone number and PIN.
  /// Returns [UserModel] on success.
  /// Throws [AppException] on failure.
  Future<UserModel> login(String phoneNumber, String pin);

  /// Log out the current user.
  Future<void> logout();
}

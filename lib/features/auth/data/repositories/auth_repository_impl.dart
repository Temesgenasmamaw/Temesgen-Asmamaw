import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_handler.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

/// Concrete implementation of [AuthRepository].
///
/// Catches raw exceptions and transforms them into domain-friendly
/// [AppException] subtypes via [ErrorHandler].
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserModel> login(String phoneNumber, String pin) async {
    try {
      return await remoteDataSource.login(phoneNumber, pin);
    } catch (e) {
      throw ErrorHandler.handle(e, 'Login failed. Please try again.');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (e) {
      throw ErrorHandler.handle(e, 'Logout failed. Please try again.');
    }
  }
}

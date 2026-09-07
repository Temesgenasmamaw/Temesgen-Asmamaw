import 'package:injectable/injectable.dart';

import '../../../../core/errors/error_handler.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<LoginResponseModel> login(LoginRequestModel payload) async {
    try {
      return await remoteDataSource.login(payload);
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

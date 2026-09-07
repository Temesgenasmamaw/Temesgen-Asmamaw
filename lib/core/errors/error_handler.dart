import 'dart:io';

import 'package:dio/dio.dart';

import 'app_exception.dart';

/// Centralized error handler that transforms raw exceptions
/// into domain-friendly [AppException] subtypes.
class ErrorHandler {
  ErrorHandler._();

  /// Transforms any caught error into an appropriate [AppException].
  ///
  /// [error] – the raw exception from network / datasource layer.
  /// [fallbackMessage] – shown when the error type is unrecognized.
  static AppException handle(dynamic error, String fallbackMessage) {
    if (error is AppException) return error;

    if (error is DioException) {
      return _handleDioError(error, fallbackMessage);
    }

    if (error is SocketException) {
      return const NetworkException();
    }

    if (error is FormatException) {
      return AppException(
        message: 'Invalid data format received.',
        code: 'FORMAT_ERROR',
      );
    }

    return AppException(message: fallbackMessage);
  }

  static AppException _handleDioError(
    DioException error,
    String fallbackMessage,
  ) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        // Extract server message if available.
        String serverMessage = fallbackMessage;
        if (data is Map<String, dynamic>) {
          final err = data['error'];
          if (err is Map<String, dynamic>) {
            serverMessage = err['details'] as String? ??
                err['message'] as String? ??
                data['message'] as String? ??
                fallbackMessage;
          } else if (err is String) {
            serverMessage = err;
          } else if (data['message'] is String) {
            serverMessage = data['message'] as String;
          }
        }

        if (statusCode == 401 || statusCode == 403) {
          return UnauthorizedException(message: serverMessage);
        }

        return ServerException(
          message: serverMessage,
          statusCode: statusCode,
        );

      case DioExceptionType.cancel:
        return const AppException(
          message: 'Request was cancelled.',
          code: 'CANCELLED',
        );

      default:
        return AppException(message: fallbackMessage);
    }
  }
}

import 'dart:convert';
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
        final rawData = error.response?.data;
        Map<String, dynamic>? data;

        if (rawData is Map<String, dynamic>) {
          data = rawData;
        } else if (rawData is Map) {
          data = Map<String, dynamic>.from(rawData);
        } else if (rawData is String && rawData.isNotEmpty) {
          try {
            final decoded = jsonDecode(rawData);
            if (decoded is Map<String, dynamic>) {
              data = decoded;
            } else if (decoded is Map) {
              data = Map<String, dynamic>.from(decoded);
            }
          } catch (_) {}
        }

        // Extract server message directly from API response
        String serverMessage = fallbackMessage;
        if (data != null) {
          final msg = data['message'] as String?;
          final err = data['error'];
          String? details;
          if (err is Map) {
            details = err['details'] as String? ?? err['message'] as String?;
          } else if (err is String) {
            details = err;
          }

          if (msg != null && msg.isNotEmpty && details != null && details.isNotEmpty) {
            serverMessage = '$msg: $details';
          } else if (msg != null && msg.isNotEmpty) {
            serverMessage = msg;
          } else if (details != null && details.isNotEmpty) {
            serverMessage = details;
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

/// Base exception class for all application-level errors.
class AppException implements Exception {
  final String message;
  final String? code;

  const AppException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'AppException(message: $message, code: $code)';
}

/// Thrown when the server returns a non-2xx response.
class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    required super.message,
    super.code,
    this.statusCode,
  });
}

/// Thrown when there is no network connectivity.
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network.',
    super.code = 'NETWORK_ERROR',
  });
}

/// Thrown when the user's session has expired or is unauthorized.
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Session expired. Please login again.',
    super.code = 'UNAUTHORIZED',
  });
}

/// Thrown when input validation fails.
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
  });
}

/// Thrown when a request times out.
class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Request timed out. Please try again.',
    super.code = 'TIMEOUT',
  });
}

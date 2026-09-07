/// Environment and networking configuration.
class EnvConfig {
  EnvConfig._();

  /// Mockfly M-Pesa Login Mock API base URL.
  static const String baseUrl =
      'https://api.mockfly.dev/mocks/5064738f-5131-4b0a-8909-ca1634e26c27';

  /// Timeout durations in seconds.
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;
}

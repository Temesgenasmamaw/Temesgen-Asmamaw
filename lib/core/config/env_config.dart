import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  static const String _defaultBaseUrl =
      'https://api.mockfly.dev/mocks/5064738f-5131-4b0a-8909-ca1634e26c27';

  static Future<void> init() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      try {
        await dotenv.load(fileName: '.env.example');
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[EnvConfig] Warning: Could not load env file: $e');
        }
      }
    }
  }

  static String get baseUrl {
    try {
      if (dotenv.isInitialized) {
        return dotenv.maybeGet('BASE_URL') ?? _defaultBaseUrl;
      }
    } catch (_) {}
    return _defaultBaseUrl;
  }

  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;
}

import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotenvUtil {
  static String getEnvironmentVariables({
    required String key,
    required String onNullValue,
  }) {
    return dotenv.env[key] ?? onNullValue;
  }
}

import 'package:logger/logger.dart';
import "package:flutter/foundation.dart";

class AppLogger {
  static final Logger logger = Logger(
    printer: PrettyPrinter(
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      levelColors: {
        Level.info: const AnsiColor.fg(2),
        Level.error: const AnsiColor.fg(4),
        Level.warning: const AnsiColor.fg(5),
      },
    ),
    level: kDebugMode ? Level.trace : Level.off,
  );
}

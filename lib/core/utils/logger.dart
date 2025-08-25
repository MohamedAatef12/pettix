import 'package:talker_flutter/talker_flutter.dart';

final talker = TalkerFlutter.init();

class AppLogger {
  static void info(String message) => talker.info(message);
  static void warning(String message) => talker.warning(message);
  static void error(dynamic error, [StackTrace? stack]) =>
      talker.handle(error, stack);
  static void debug(String message) => talker.debug(message);
}

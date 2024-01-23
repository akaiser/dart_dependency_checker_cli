import 'dart:io' show stdout, stderr;

import 'package:yaansi/yaansi.dart';

class Logger {
  const Logger();

  void info(String message) => stdout.writeln(green(message));

  void warn(String message) => stdout.writeln(yellow(message));

  void error(String message) => stderr.writeln(red(message));
}

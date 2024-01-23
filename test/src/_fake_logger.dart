import 'dart:io';

import 'package:dart_dependency_checker_cli/src/util/logger.dart';

class FakeLogger implements Logger {
  var infoMessage = '', warnMessage = '', errorMessage = '';

  @override
  void info(String message) => infoMessage += message.withNewLine;

  @override
  void warn(String message) => warnMessage += message.withNewLine;

  @override
  void error(String message) => errorMessage += message.withNewLine;
}

extension on String {
  String get withNewLine => '$this${Platform.lineTerminator}';
}

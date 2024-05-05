import 'package:dart_dependency_checker_cli/src/_logger/_json_logger.dart';
import 'package:dart_dependency_checker_cli/src/_logger/_plain_logger.dart';
import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';

class ResultsLogger {
  const ResultsLogger();

  int logWithExit(LogParams params, [bool jsonOutput = false]) {
    if (jsonOutput) {
      JsonLogger.log(params);
    } else {
      PlainLogger.log(params);
    }
    return params.exitCode;
  }
}

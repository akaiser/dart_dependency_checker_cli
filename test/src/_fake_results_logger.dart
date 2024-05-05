import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_logger.dart';

class FakeResultsLogger implements ResultsLogger {
  late final LogParams params;

  @override
  int logWithExit(LogParams params, [bool jsonOutput = false]) {
    this.params = params;
    return 0;
  }
}

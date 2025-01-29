import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_logger.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_status.dart';
import 'package:dart_dependency_checker_cli/src/_shared/check_mixin.dart';

class DepsUsedChecker extends lib.DepsUsedChecker with CheckerMixin {
  const DepsUsedChecker(
    super.params, {
    required this.jsonOutput,
    this.logger = const ResultsLogger(),
  });

  final ResultsLogger logger;
  final bool jsonOutput;

  @override
  int checkWithExit() {
    late final LogParams logParams;
    final path = params.path;

    try {
      final results = super.check();

      logParams = LogParams(
        ResultsStatus.clear,
        path,
        message: '${results.isEmpty ? 'No' : 'Some'} dependencies found.',
        results: results,
      );
    } on lib.CheckerError catch (e) {
      logParams = LogParams(
        ResultsStatus.error,
        path,
        error: e.message,
      );
    }

    return logger.logWithExit(logParams, jsonOutput);
  }
}

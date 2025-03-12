import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_logger.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_status.dart';
import 'package:dart_dependency_checker_cli/src/_shared/performer_mixin.dart';

class TransitiveUseChecker extends lib.TransitiveUseChecker
    with PerformerMixin {
  const TransitiveUseChecker(
    super.params, {
    required this.jsonOutput,
    this.logger = const ResultsLogger(),
  });

  final ResultsLogger logger;
  final bool jsonOutput;

  @override
  int performWithExit() {
    late final LogParams logParams;
    final path = params.path;

    try {
      final results = super.perform();

      logParams = results.isEmpty
          ? LogParams(
              ResultsStatus.clear,
              path,
              message: 'All clear!',
            )
          : LogParams(
              ResultsStatus.warning,
              path,
              message: 'Found undeclared/transitive packages.',
              results: results,
            );
    } on lib.PerformerError catch (e) {
      logParams = LogParams(
        ResultsStatus.error,
        path,
        error: e.message,
      );
    }

    return logger.logWithExit(logParams, jsonOutput);
  }
}

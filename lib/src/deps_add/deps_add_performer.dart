import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_logger.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_status.dart';
import 'package:dart_dependency_checker_cli/src/_shared/performer_mixin.dart';

class DepsAddPerformer extends lib.DepsAddPerformer with PerformerMixin {
  const DepsAddPerformer(
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
      final result = super.perform();

      logParams = LogParams(
        result ? ResultsStatus.clear : ResultsStatus.warning,
        path,
        message: result ? 'Packages added.' : 'No packages added.',
        results: DepsAddResults(
          mainDependencies: result ? params.main : const {},
          devDependencies: result ? params.dev : const {},
        ),
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

class DepsAddResults extends lib.BaseResults {
  const DepsAddResults({
    required super.mainDependencies,
    required super.devDependencies,
  });
}

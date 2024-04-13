import 'dart:io';

import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_shared/check_mixin.dart';
import 'package:dart_dependency_checker_cli/src/util/logger.dart';

class TransitiveUseChecker extends lib.TransitiveUseChecker
    with CheckWithExitMixin {
  const TransitiveUseChecker(super.params, [this.logger = const Logger()]);

  final Logger logger;

  @override
  int checkWithExit() {
    try {
      final results = check();

      if (!results.isEmpty) {
        logger.warn('== Found undeclared/transitive packages ==');
        logger.warn('Path: ${params.path}/pubspec.yaml');
        _printDependencies('Dependencies', results.mainDependencies);
        _printDependencies('Dev Dependencies', results.devDependencies);
        return 1;
      }
    } on lib.CheckerError catch (e) {
      logger.error(e.message);
      return 2;
    }

    logger.info('All clear!');
    return exitCode;
  }

  void _printDependencies(String label, Set<String> dependencies) {
    if (dependencies.isNotEmpty) {
      logger.warn('$label:');
      for (final dependency in dependencies) {
        logger.warn('  - $dependency');
      }
    }
  }
}

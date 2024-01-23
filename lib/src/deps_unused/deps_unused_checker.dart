import 'dart:io';

import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/util/check_mixin.dart';
import 'package:dart_dependency_checker_cli/src/util/logger.dart';

class DepsUnusedChecker extends lib.DepsUnusedChecker with CheckWithExitMixin {
  const DepsUnusedChecker(super.params, [this.logger = const Logger()]);

  final Logger logger;

  @override
  int checkWithExit() {
    try {
      final results = check();

      if (!results.isEmpty) {
        final messagePrefix = params.fix ? 'Fixed' : 'Found';
        logger.warn('== $messagePrefix unused packages ==');
        logger.warn('Path: ${params.path}/pubspec.yaml');
        _printDependencies('Dependencies', results.dependencies);
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

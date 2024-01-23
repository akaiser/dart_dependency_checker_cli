import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/deps_unused/deps_unused_checker.dart';

const // options
    _pathOption = 'path',
    _devIgnoresOption = 'dev-ignores',
    _mainIgnoresOption = 'main-ignores';

const // flags
    _fixFlag = 'fix';

class DepsUnusedCommand extends Command<int> {
  DepsUnusedCommand() {
    argParser
      ..addOption(
        _pathOption,
        abbr: _pathOption[0],
        help: 'Path to valid pubspec.yaml.',
      )
      ..addMultiOption(
        _devIgnoresOption,
        help: 'Comma separated list of dev dependencies to be ignored.',
      )
      ..addMultiOption(
        _mainIgnoresOption,
        help: 'Comma separated list of main dependencies to be ignored.',
      )
      ..addFlag(
        _fixFlag,
        negatable: false,
        help: 'Instant cleanup after checker run.',
      );
  }

  @override
  final name = 'deps-unused';

  @override
  final description = 'Checks and fixes unused dependencies.';

  @override
  int run() {
    final argResults = this.argResults;
    final params = lib.DepsUnusedParams(
      path: argResults?.option<String>(_pathOption) ?? Directory.current.path,
      devIgnores: argResults?.optionValues(_devIgnoresOption) ?? const {},
      mainIgnores: argResults?.optionValues(_mainIgnoresOption) ?? const {},
      fix: argResults?.option<bool>(_fixFlag) ?? false,
    );

    return DepsUnusedChecker(params).checkWithExit();
  }
}

extension on ArgResults {
  T? option<T>(String key) => options.contains(key) ? this[key] as T : null;

  Set<String> optionValues(String key) =>
      (this[key] as List<String>).where((v) => v.isNotEmpty).toSet();
}

import 'dart:io';

import 'package:args/args.dart';

const // options
    _pathOption = 'path',
    _mainIgnoresOption = 'main-ignores',
    _devIgnoresOption = 'dev-ignores';

const // flags
    _fixFlag = 'fix';

extension ArgParserExt on ArgParser {
  void get withPathOption => addOption(
        _pathOption,
        abbr: _pathOption[0],
        valueHelp: 'path',
        help: 'Path to valid pubspec.yaml.',
      );

  void get withMainIgnoresOption => addMultiOption(
        _mainIgnoresOption,
        help: 'Comma separated list of main dependencies to be ignored.',
      );

  void get withDevIgnoresOption => addMultiOption(
        _devIgnoresOption,
        help: 'Comma separated list of dev dependencies to be ignored.',
      );

  void get withFixFlag => addFlag(
        _fixFlag,
        help: 'Instant cleanup after checker run.',
      );
}

extension ArgResultsExt on ArgResults? {
  String get path => this?.option(_pathOption) ?? Directory.current.path;

  Set<String> get mainIgnores =>
      this?.multiOption(_mainIgnoresOption).toSet() ?? const {};

  Set<String> get devIgnores =>
      this?.multiOption(_devIgnoresOption).toSet() ?? const {};

  bool get fix => this?.flag(_fixFlag) ?? false;
}

import 'dart:io';

import 'package:args/args.dart';

const // options
    _path = 'path',
    _mainIgnores = 'main-ignores',
    _devIgnores = 'dev-ignores';

const // flags
    _fix = 'fix';

extension ArgParserExt on ArgParser {
  void get withPathOption => addOption(
        _path,
        abbr: _path[0],
        valueHelp: 'path',
        help: 'Path to valid pubspec.yaml.',
      );

  void get withMainIgnoresMultiOption => addMultiOption(
        _mainIgnores,
        help: 'Comma separated list of main dependencies to be ignored.',
      );

  void get withDevIgnoresMultiOption => addMultiOption(
        _devIgnores,
        help: 'Comma separated list of dev dependencies to be ignored.',
      );

  void get withFixFlag => addFlag(
        _fix,
        help: 'Instant cleanup after checker run.',
      );
}

extension ArgResultsExt on ArgResults? {
  String get path => this?.option(_path) ?? Directory.current.path;

  Set<String> get mainIgnores =>
      this?.multiOption(_mainIgnores).toSet() ?? const {};

  Set<String> get devIgnores =>
      this?.multiOption(_devIgnores).toSet() ?? const {};

  bool get fix => this?.flag(_fix) ?? false;
}

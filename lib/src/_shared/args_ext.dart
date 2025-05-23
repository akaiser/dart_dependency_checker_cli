import 'dart:io';

import 'package:args/args.dart';

const // options
    _path = 'path',
    _main = 'main',
    _dev = 'dev',
    _mainIgnores = 'main-ignores',
    _devIgnores = 'dev-ignores';

const // flags
    _fix = 'fix',
    _json = 'json';

extension ArgParserExt on ArgParser {
  void get withPathOption => addOption(
        _path,
        abbr: _path[0],
        valueHelp: 'path',
        help: 'Path to valid pubspec.yaml.',
      );

  void get withMainMultiOption => addMultiOption(
        _main,
        aliases: const ['m'],
        help: 'Comma separated list of main dependencies.',
      );

  void get withDevMultiOption => addMultiOption(
        _dev,
        aliases: const ['d'],
        help: 'Comma separated list of dev dependencies.',
      );

  void get withMainIgnoresMultiOption => addMultiOption(
        _mainIgnores,
        aliases: const ['mi'],
        help: 'Comma separated list of main dependencies to be ignored.',
      );

  void get withDevIgnoresMultiOption => addMultiOption(
        _devIgnores,
        aliases: const ['di'],
        help: 'Comma separated list of dev dependencies to be ignored.',
      );

  void get withFixFlag => addFlag(
        _fix,
        help: 'Instant cleanup after checker run.',
      );

  void get withJsonFlag => addFlag(
        _json,
        help: 'Output in json format.',
      );
}

extension ArgResultsExt on ArgResults? {
  String get path => this?.option(_path) ?? Directory.current.path;

  Set<String> _multiOption(String option) =>
      this?.multiOption(option).toSet() ?? const {};

  Set<String> get main => _multiOption(_main);

  Set<String> get dev => _multiOption(_dev);

  Set<String> get mainIgnores => _multiOption(_mainIgnores);

  Set<String> get devIgnores => _multiOption(_devIgnores);

  bool get fix => this?.flag(_fix) ?? false;

  bool get json => this?.flag(_json) ?? false;
}

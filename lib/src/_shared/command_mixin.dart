import 'dart:io';

import 'package:args/args.dart';

const // options
    _pathOption = 'path',
    _mainIgnoresOption = 'main-ignores',
    _devIgnoresOption = 'dev-ignores';

const // flags
    _fixFlag = 'fix';

mixin CommandMixin {
  void withPathOption(ArgParser argParser) => argParser.addOption(
        _pathOption,
        abbr: _pathOption[0],
        valueHelp: 'path',
        help: 'Path to valid pubspec.yaml.',
      );

  void withMainIgnoresOption(ArgParser argParser) => argParser.addMultiOption(
        _mainIgnoresOption,
        help: 'Comma separated list of main dependencies to be ignored.',
      );

  void withDevIgnoresOption(ArgParser argParser) => argParser.addMultiOption(
        _devIgnoresOption,
        help: 'Comma separated list of dev dependencies to be ignored.',
      );

  void withFixFlag(ArgParser argParser) => argParser.addFlag(
        _fixFlag,
        help: 'Instant cleanup after checker run.',
      );

  String resolvePathOption(ArgResults? argResults) =>
      argResults?.option(_pathOption) ?? Directory.current.path;

  Set<String> resolveMainIgnoresOption(ArgResults? argResults) =>
      argResults?.multiOption(_mainIgnoresOption).toSet() ?? const {};

  Set<String> resolveDevIgnoresOption(ArgResults? argResults) =>
      argResults?.multiOption(_devIgnoresOption).toSet() ?? const {};

  bool resolveFixFlag(ArgResults? argResults) =>
      argResults?.flag(_fixFlag) ?? false;
}

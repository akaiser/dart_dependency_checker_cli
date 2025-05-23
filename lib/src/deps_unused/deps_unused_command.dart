import 'package:args/command_runner.dart';
import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_shared/args_ext.dart';
import 'package:dart_dependency_checker_cli/src/deps_unused/deps_unused_checker.dart';

class DepsUnusedCommand extends Command<int> {
  DepsUnusedCommand() {
    argParser
      ..withPathOption
      ..withMainIgnoresMultiOption
      ..withDevIgnoresMultiOption
      ..withFixFlag
      ..withJsonFlag;
  }

  @override
  final name = 'deps-unused';

  @override
  List<String> get aliases => const ['dun'];

  @override
  final description =
      'Checks and fixes via pubspec.yaml declared but unused dependencies.';

  @override
  int run() => DepsUnusedChecker(
        lib.DepsUnusedParams(
          path: argResults.path,
          mainIgnores: argResults.mainIgnores,
          devIgnores: argResults.devIgnores,
          fix: argResults.fix,
        ),
        jsonOutput: argResults.json,
      ).performWithExit();
}

import 'package:args/command_runner.dart';
import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_shared/args_ext.dart';
import 'package:dart_dependency_checker_cli/src/deps_used/deps_used_checker.dart';

class DepsUsedCommand extends Command<int> {
  DepsUsedCommand() {
    argParser
      ..withPathOption
      ..withMainIgnoresMultiOption
      ..withDevIgnoresMultiOption
      ..withJsonFlag;
  }

  @override
  final name = 'deps-used';

  @override
  List<String> get aliases => const ['du'];

  @override
  final description = 'Checks used dependencies via imports only.';

  @override
  int run() => DepsUsedChecker(
        lib.DepsUsedParams(
          path: argResults.path,
          mainIgnores: argResults.mainIgnores,
          devIgnores: argResults.devIgnores,
        ),
        jsonOutput: argResults.json,
      ).checkWithExit();
}

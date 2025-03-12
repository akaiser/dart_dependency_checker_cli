import 'package:args/command_runner.dart';
import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_shared/args_ext.dart';
import 'package:dart_dependency_checker_cli/src/deps_add/deps_add_performer.dart';

class DepsAddCommand extends Command<int> {
  DepsAddCommand() {
    argParser
      ..withPathOption
      ..withMainMultiOption
      ..withDevMultiOption
      ..withJsonFlag;
  }

  @override
  final name = 'deps-add';

  @override
  List<String> get aliases => const ['da'];

  @override
  final description = 'Adds main and dev dependencies to a pubspec.yaml file.';

  @override
  int run() => DepsAddPerformer(
        lib.DepsAddParams(
          path: argResults.path,
          main: argResults.main,
          dev: argResults.dev,
        ),
        jsonOutput: argResults.json,
      ).performWithExit();
}

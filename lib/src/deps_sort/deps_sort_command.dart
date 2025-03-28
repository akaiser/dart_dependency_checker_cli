import 'package:args/command_runner.dart';
import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_shared/args_ext.dart';
import 'package:dart_dependency_checker_cli/src/deps_sort/deps_sort_performer.dart';

class DepsSortCommand extends Command<int> {
  DepsSortCommand() {
    argParser
      ..withPathOption
      ..withJsonFlag;
  }

  @override
  final name = 'deps-sort';

  @override
  List<String> get aliases => const ['ds'];

  @override
  final description = 'Sorts main and dev dependencies in a pubspec.yaml file.';

  @override
  int run() => DepsSortPerformer(
        lib.DepsSortParams(path: argResults.path),
        jsonOutput: argResults.json,
      ).performWithExit();
}

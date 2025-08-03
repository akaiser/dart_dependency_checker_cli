import 'package:args/command_runner.dart';
import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_shared/args_ext.dart';
import 'package:dart_dependency_checker_cli/src/deps_update/deps_update_performer.dart';

class DepsUpdateCommand extends Command<int> {
  DepsUpdateCommand() {
    argParser
      ..withPathOption
      ..withMainMultiOption
      ..withDevMultiOption
      ..withJsonFlag;
  }

  @override
  final name = 'deps-update';

  @override
  List<String> get aliases => const ['dup'];

  @override
  final description =
      'Updates provided but only existing main and dev dependencies in a pubspec.yaml file.';

  @override
  int run() => DepsUpdatePerformer(
        lib.DepsUpdateParams(
          path: argResults.path,
          main: argResults.main,
          dev: argResults.dev,
        ),
        jsonOutput: argResults.json,
      ).performWithExit();
}

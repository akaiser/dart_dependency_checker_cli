import 'package:args/command_runner.dart';
import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_shared/args_ext.dart';
import 'package:dart_dependency_checker_cli/src/transitive_use/transitive_use_checker.dart';

class TransitiveUseCommand extends Command<int> {
  TransitiveUseCommand() {
    argParser
      ..withPathOption
      ..withMainIgnoresMultiOption
      ..withDevIgnoresMultiOption
      ..withJsonFlag;
  }

  @override
  final name = 'transitive-use';

  @override
  List<String> get aliases => const ['tu'];

  @override
  final description =
      'Checks direct use of pubspec.yaml undeclared aka. transitive dependencies.';

  @override
  int run() => TransitiveUseChecker(
        lib.TransitiveUseParams(
          path: argResults.path,
          mainIgnores: argResults.mainIgnores,
          devIgnores: argResults.devIgnores,
        ),
        jsonOutput: argResults.json,
      ).performWithExit();
}

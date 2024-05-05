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
  final description = 'Checks direct use of undeclared/transitive dependencies';

  @override
  int run() {
    final params = lib.TransitiveUseParams(
      path: argResults.path,
      mainIgnores: argResults.mainIgnores,
      devIgnores: argResults.devIgnores,
    );

    return TransitiveUseChecker(
      params,
      jsonOutput: argResults.json,
    ).checkWithExit();
  }
}

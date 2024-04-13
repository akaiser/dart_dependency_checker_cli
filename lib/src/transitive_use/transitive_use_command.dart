import 'package:args/command_runner.dart';
import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_shared/command_mixin.dart';
import 'package:dart_dependency_checker_cli/src/transitive_use/transitive_use_checker.dart';

class TransitiveUseCommand extends Command<int> with CommandMixin {
  TransitiveUseCommand() {
    withPathOption(argParser);
    withMainIgnoresOption(argParser);
    withDevIgnoresOption(argParser);
  }

  @override
  final name = 'transitive-use';

  @override
  final description = 'Checks direct use of undeclared/transitive dependencies';

  @override
  int run() {
    final argResults = this.argResults;
    final params = lib.TransitiveUseParams(
      path: resolvePathOption(argResults),
      mainIgnores: resolveMainIgnoresOption(argResults),
      devIgnores: resolveDevIgnoresOption(argResults),
    );

    return TransitiveUseChecker(params).checkWithExit();
  }
}

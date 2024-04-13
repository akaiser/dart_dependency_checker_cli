import 'package:args/command_runner.dart';
import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_shared/command_mixin.dart';
import 'package:dart_dependency_checker_cli/src/deps_unused/deps_unused_checker.dart';

class DepsUnusedCommand extends Command<int> with CommandMixin {
  DepsUnusedCommand() {
    withPathOption(argParser);
    withMainIgnoresOption(argParser);
    withDevIgnoresOption(argParser);
    withFixFlag(argParser);
  }

  @override
  final name = 'deps-unused';

  @override
  final description = 'Checks and fixes unused dependencies.';

  @override
  int run() {
    final argResults = this.argResults;
    final params = lib.DepsUnusedParams(
      path: resolvePathOption(argResults),
      mainIgnores: resolveMainIgnoresOption(argResults),
      devIgnores: resolveDevIgnoresOption(argResults),
      fix: resolveFixFlag(argResults),
    );

    return DepsUnusedChecker(params).checkWithExit();
  }
}

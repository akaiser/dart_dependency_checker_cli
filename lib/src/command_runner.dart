import 'package:args/command_runner.dart' as args;
import 'package:dart_dependency_checker_cli/src/deps_unused/deps_unused_command.dart';
import 'package:dart_dependency_checker_cli/src/transitive_use/transitive_use_command.dart';

const versionFlag = 'version';

final class CommandRunner extends args.CommandRunner<int> {
  CommandRunner()
      : super(
          'ddc',
          'A utility package for checking dependencies within Dart/Flutter packages.',
        ) {
    argParser.addFlag(
      versionFlag,
      negatable: false,
      help: 'Print this package version.',
    );
    addCommand(DepsUnusedCommand());
    addCommand(TransitiveUseCommand());
  }
}

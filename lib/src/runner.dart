import 'package:args/command_runner.dart';
import 'package:dart_dependency_checker_cli/src/deps_unused/deps_unused_command.dart';

Future<int?> run(List<String> args) async {
  try {
    final runner = CommandRunner<int>(
      'ddc',
      'A utility package for checking dependencies within Dart/Flutter packages.',
    )..addCommand(DepsUnusedCommand());

    return (runner..parse(args)).run(args);
  } catch (e) {
    print(e);
    return 1;
  }
}

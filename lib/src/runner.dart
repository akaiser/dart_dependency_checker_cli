import 'package:args/command_runner.dart' show UsageException;
import 'package:dart_dependency_checker_cli/src/command_runner.dart';
import 'package:dart_dependency_checker_cli/src/util/version.dart';

Future<int?> run(List<String> args) async {
  try {
    final runner = CommandRunner();
    final results = runner.parse(args);
    if (results.wasParsed(versionFlag)) {
      print('ddc v$packageVersion');
      return null;
    }
    return runner.run(args);
  } on UsageException catch (e) {
    print(e);
    return 64;
  }
}

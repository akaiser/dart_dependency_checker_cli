import 'dart:io' show exit;

import 'package:dart_dependency_checker_cli/src/runner.dart' show run;

Future<void> main(List<String> args) async => exit(await run(args) ?? 0);

/// A utility package for checking dependencies within Dart/Flutter packages.
///
/// ## Usage
///
/// Install:
/// ```bash
/// dart pub global activate dart_dependency_checker_cli
/// ```
///
/// Run:
/// ```bash
/// ddc deps-unused -p /some/package --dev-ignores lints,build_runner
/// ```
library dart_dependency_checker_cli;

import 'dart:io' show exit;

import 'package:dart_dependency_checker_cli/src/runner.dart' show run;

/// Starts this utility execution.
Future<void> main(List<String> args) async => exit(await run(args) ?? 0);

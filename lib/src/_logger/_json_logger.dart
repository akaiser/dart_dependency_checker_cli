import 'dart:convert';
import 'dart:io' show stdout;

import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';
import 'package:dart_dependency_checker_cli/src/_shared/iterable_ext.dart';

abstract final class JsonLogger {
  static void log(LogParams params, [StringBuffer? b]) {
    final buffer = (b ?? StringBuffer())..writeln(params.toJsonString());
    stdout.write('$buffer');
  }
}

extension on LogParams {
  String toJsonString() {
    final mainDependencies = results?.mainDependencies.unmodifiable;
    final devDependencies = results?.devDependencies.unmodifiable;

    return jsonEncode({
      'path': path,
      'message': message,
      'exitCode': resultStatus.exitCode,
      'error': error,
      if (mainDependencies == null && devDependencies == null)
        'results': null
      else
        'results': {
          'mainDependencies': mainDependencies,
          'devDependencies': devDependencies,
        },
    });
  }
}

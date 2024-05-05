import 'dart:io' show stdout, stderr;

import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_status.dart';
import 'package:yaansi/yaansi.dart';

abstract final class PlainLogger {
  static void log(LogParams params, [StringBuffer? b]) {
    final buffer = b ?? StringBuffer()
      ..writeln('================ DDC ================')
      ..writeln('Path: ${params.path}/pubspec.yaml');

    final resultStatus = params.resultStatus;

    switch (resultStatus) {
      case ResultsStatus.clear:
      case ResultsStatus.warning:
        buffer
          ..writeln('Message: ${params.message}')
          ..writeDependencies(
            'Dependencies',
            params.results?.mainDependencies,
          )
          ..writeDependencies(
            'Dev Dependencies',
            params.results?.devDependencies,
          );
        break;
      case ResultsStatus.error:
        buffer.writeln('Error: ${params.error}');
        break;
    }

    resultStatus.write('$buffer');
  }
}

extension on StringBuffer {
  void writeDependencies(String label, Set<String>? dependencies) {
    if (dependencies != null && dependencies.isNotEmpty) {
      writeln('$label:');
      for (final dependency in dependencies) {
        writeln('  - $dependency');
      }
    }
  }
}

extension on ResultsStatus {
  void write(String message) => switch (this) {
        ResultsStatus.error => stderr.write(_yaansi(message)),
        _ => stdout.write(_yaansi(message)),
      };

  String Function(String message) get _yaansi => switch (this) {
        ResultsStatus.clear => green,
        ResultsStatus.warning => yellow,
        ResultsStatus.error => red,
      };
}

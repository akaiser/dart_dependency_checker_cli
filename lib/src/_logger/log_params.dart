import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_logger/results_status.dart';
import 'package:equatable/equatable.dart';

class LogParams extends Equatable {
  const LogParams(
    this.resultStatus,
    this.path, {
    this.message,
    this.results,
    this.error,
  });

  final ResultsStatus resultStatus;
  final String path;
  final String? message;
  final lib.BaseResults? results;
  final String? error;

  int get exitCode => resultStatus.exitCode;

  @override
  List<Object?> get props => [resultStatus, path, message, results, error];
}

import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_logger/_json_logger.dart';
import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_status.dart';
import 'package:test/test.dart';

void main() {
  late StringBuffer buffer;

  setUp(() => buffer = StringBuffer());

  test('log on ${ResultsStatus.clear}', () {
    JsonLogger.log(
      const LogParams(
        ResultsStatus.clear,
        'any/path',
        message: 'All clear!',
      ),
      buffer,
    );

    expect(
      '$buffer',
      '{"path":"any/path","message":"All clear!","exitCode":0,"error":null,"results":{"mainDependencies":null,"devDependencies":null}}\n',
    );
  });

  test('log on ${ResultsStatus.warning}', () {
    JsonLogger.log(
      const LogParams(
        ResultsStatus.warning,
        'any/path',
        message: 'any message',
        results: lib.DepsUnusedResults(
          mainDependencies: {'dep1'},
          devDependencies: {'dev_dep1', 'dev_dep2'},
        ),
      ),
      buffer,
    );

    expect(
      '$buffer',
      '{"path":"any/path","message":"any message","exitCode":1,"error":null,"results":{"mainDependencies":["dep1"],"devDependencies":["dev_dep1","dev_dep2"]}}\n',
    );
  });

  test('log on ${ResultsStatus.error}', () {
    JsonLogger.log(
      const LogParams(
        ResultsStatus.error,
        'any/path',
        error: 'Explosion somewhere!',
      ),
      buffer,
    );

    expect(
      '$buffer',
      '{"path":"any/path","message":null,"exitCode":2,"error":"Explosion somewhere!","results":{"mainDependencies":null,"devDependencies":null}}\n',
    );
  });
}

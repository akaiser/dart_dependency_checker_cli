import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_logger/_plain_logger.dart';
import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_status.dart';
import 'package:test/test.dart';

void main() {
  late StringBuffer buffer;

  setUp(() => buffer = StringBuffer());

  test('log on ${ResultsStatus.clear}', () {
    PlainLogger.log(
      const LogParams(
        ResultsStatus.clear,
        'any/path',
        message: 'All clear!',
      ),
      buffer,
    );

    expect('$buffer', '''
================ DDC ================
Path: any/path
Message: All clear!
''');
  });

  test('log on ${ResultsStatus.warning}', () {
    PlainLogger.log(
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

    expect('$buffer', '''
================ DDC ================
Path: any/path
Message: any message
Dependencies:
  - dep1
Dev Dependencies:
  - dev_dep1
  - dev_dep2
''');
  });

  test('log on ${ResultsStatus.error}', () {
    PlainLogger.log(
      const LogParams(
        ResultsStatus.error,
        'any/path',
        error: 'Explosion somewhere!',
      ),
      buffer,
    );

    expect('$buffer', '''
================ DDC ================
Path: any/path
Error: Explosion somewhere!
''');
  });
}

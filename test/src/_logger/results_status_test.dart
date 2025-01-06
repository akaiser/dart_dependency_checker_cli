import 'package:dart_dependency_checker_cli/src/_logger/results_status.dart';
import 'package:test/test.dart';

void main() {
  test('has known value', () {
    expect(ResultsStatus.values, const {
      ResultsStatus.clear,
      ResultsStatus.warning,
      ResultsStatus.error,
    });
  });

  const <ResultsStatus, int>{
    ResultsStatus.clear: 0,
    ResultsStatus.warning: 1,
    ResultsStatus.error: 2,
  }.forEach((status, exitCode) {
    test('$status maps to $exitCode exitCode', () {
      expect(status.exitCode, exitCode);
    });
  });
}

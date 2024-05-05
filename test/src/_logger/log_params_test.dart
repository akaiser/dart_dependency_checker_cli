import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_status.dart';
import 'package:test/test.dart';

void main() {
  const tested = LogParams(
    ResultsStatus.warning,
    'path',
    message: 'message',
    results: null,
    error: 'error',
  );

  test('has known props count', () {
    expect(tested.props, hasLength(5));
  });
}

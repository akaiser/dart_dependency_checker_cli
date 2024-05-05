import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_logger.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_status.dart';
import 'package:test/test.dart';

void main() {
  late ResultsLogger tested;

  setUp(() => tested = const ResultsLogger());

  test('logWithExit on ${ResultsStatus.clear}', () {
    final exitCode = tested.logWithExit(
      const LogParams(ResultsStatus.clear, 'any'),
    );

    expect(exitCode, 0);
  });

  test('logWithExit on ${ResultsStatus.warning}', () {
    final exitCode = tested.logWithExit(
      const LogParams(ResultsStatus.warning, 'any'),
    );

    expect(exitCode, 1);
  });

  test('logWithExit on ${ResultsStatus.error}', () {
    final exitCode = tested.logWithExit(
      const LogParams(ResultsStatus.error, 'any'),
    );

    expect(exitCode, 2);
  });
}

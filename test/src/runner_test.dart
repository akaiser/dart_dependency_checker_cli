import 'package:args/command_runner.dart';
import 'package:dart_dependency_checker_cli/src/runner.dart';
import 'package:test/test.dart';

import '_paths.dart';

void main() {
  test('gives 1 as result when unknown flag provided', () async {
    expect(await run(const ['-q']), 1);
  });

  test('gives null as result when known flag provided', () async {
    expect(await run(const ['-h']), isNull);
  });

  test('gives null as result when no command provided', () async {
    expect(await run(const []), isNull);
  });

  test('throws $UsageException when invalid command provided', () {
    expect(
      () => run(const ['invalid']),
      throwsA(
        isA<UsageException>().having(
          (exception) => exception.message,
          'message',
          'Could not find a command named "invalid".',
        ),
      ),
    );
  });

  test(
      'gives 0 as result when deps-unused command '
      'and path to clean pubspec.yaml provided', () async {
    expect(await run(const ['deps-unused', '-p', noDependenciesPath]), 0);
  });
}

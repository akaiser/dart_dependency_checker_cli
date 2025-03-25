import 'package:dart_dependency_checker_cli/src/runner.dart';
import 'package:test/test.dart';

import '_paths.dart';

void main() {
  test('gives 64 as result when unknown flag provided', () async {
    expect(await run(const ['-q']), 64);
  });

  test('gives 64 as result when unknown command provided', () async {
    expect(await run(const ['unknown']), 64);
  });

  test('gives null as result when known -h provided', () async {
    expect(await run(const ['-h']), isNull);
  });

  test('gives null as result when known --version provided', () async {
    expect(await run(const ['--version']), isNull);
  });

  test('gives null as result when no command provided', () async {
    expect(await run(const []), isNull);
  });

  test(
      'gives 0 as result when deps-unused command '
      'and path to clean pubspec.yaml provided', () async {
    expect(await run(const ['deps-unused', '-p', noDependenciesPath]), 0);
  });
}

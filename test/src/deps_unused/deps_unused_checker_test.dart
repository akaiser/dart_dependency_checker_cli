import 'package:dart_dependency_checker/src/deps_unused/deps_unused_params.dart';
import 'package:dart_dependency_checker_cli/src/deps_unused/deps_unused_checker.dart';
import 'package:test/test.dart';

import '../_fake_logger.dart';
import '../_paths.dart';

void main() {
  late FakeLogger logger;

  setUp(() => logger = FakeLogger());

  test('reports error on invalid pubspec.yaml path', () {
    final result = DepsUnusedChecker(
      const DepsUnusedParams(path: 'unknown'),
      logger,
    ).checkWithExit();

    expect(result, 2);
    expect(logger.errorMessage, '''
Invalid pubspec.yaml file path: unknown/pubspec.yaml
''');
  });

  test('reports error on invalid pubspec.yaml content', () {
    final result = DepsUnusedChecker(
      const DepsUnusedParams(path: emptyYamlPath),
      logger,
    ).checkWithExit();

    expect(result, 2);
    expect(logger.errorMessage, '''
Invalid pubspec.yaml file contents in: $emptyYamlPath/pubspec.yaml
''');
  });

  group('providing all_sources_dirs path', () {
    const path = allSourcesDirsPath;

    test('reports only unused main and dev dependencies', () {
      final result = DepsUnusedChecker(
        const DepsUnusedParams(path: path),
        logger,
      ).checkWithExit();

      expect(result, 1);
      expect(logger.warnMessage, '''
== Found unused packages ==
Path: $path/pubspec.yaml
Dependencies:
  - meta
Dev Dependencies:
  - integration_test
  - lints
''');
    });

    test('passed ignores will not be reported', () {
      final result = DepsUnusedChecker(
        const DepsUnusedParams(
          path: path,
          devIgnores: {'integration_test'},
        ),
        logger,
      ).checkWithExit();

      expect(result, 1);
      expect(logger.warnMessage, '''
== Found unused packages ==
Path: $path/pubspec.yaml
Dependencies:
  - meta
Dev Dependencies:
  - lints
''');
    });
  });

  group('providing no_dependencies path', () {
    test('reports no unused dependencies', () {
      final result = DepsUnusedChecker(
        const DepsUnusedParams(path: noDependenciesPath),
        logger,
      ).checkWithExit();

      expect(result, 0);
      expect(logger.infoMessage, '''
All clear!
''');
    });
  });

  group('providing no_sources_dirs path', () {
    const path = noSourcesDirsPath;

    test('reports all declared main and dev dependencies', () {
      final result = DepsUnusedChecker(
        const DepsUnusedParams(path: path),
        logger,
      ).checkWithExit();

      expect(result, 1);
      expect(
        logger.warnMessage,
        '''
== Found unused packages ==
Path: $path/pubspec.yaml
Dependencies:
  - meta
Dev Dependencies:
  - lints
  - test
''',
      );
    });

    test(
        'passed ignores will not be reported '
        'even if no sources were found', () {
      final result = DepsUnusedChecker(
        const DepsUnusedParams(
          path: path,
          devIgnores: {'lints', 'test'},
        ),
        logger,
      ).checkWithExit();

      expect(result, 1);
      expect(
        logger.warnMessage,
        '''
== Found unused packages ==
Path: $path/pubspec.yaml
Dependencies:
  - meta
''',
      );
    });
  });
}

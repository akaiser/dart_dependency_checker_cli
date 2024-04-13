import 'package:dart_dependency_checker/src/transitive_use/transitive_use_params.dart';
import 'package:dart_dependency_checker_cli/src/transitive_use/transitive_use_checker.dart';
import 'package:test/test.dart';

import '../_fake_logger.dart';
import '../_paths.dart';

void main() {
  late FakeLogger logger;

  setUp(() => logger = FakeLogger());

  test('reports error on invalid pubspec.yaml path', () {
    final result = TransitiveUseChecker(
      const TransitiveUseParams(path: 'unknown'),
      logger,
    ).checkWithExit();

    expect(result, 2);
    expect(logger.errorMessage, '''
Invalid pubspec.yaml file path: unknown/pubspec.yaml
''');
  });

  test('reports error on invalid pubspec.yaml content', () {
    final result = TransitiveUseChecker(
      const TransitiveUseParams(path: emptyYamlPath),
      logger,
    ).checkWithExit();

    expect(result, 2);
    expect(logger.errorMessage, '''
Invalid pubspec.yaml file contents in: $emptyYamlPath/pubspec.yaml
''');
  });

  group('providing all_sources_dirs_multi path', () {
    const path = allSourcesDirsMultiPath;

    test('reports only undeclared main and dev dependencies', () {
      final result = TransitiveUseChecker(
        const TransitiveUseParams(path: path),
        logger,
      ).checkWithExit();

      expect(result, 1);
      expect(logger.warnMessage, '''
== Found undeclared/transitive packages ==
Path: $path/pubspec.yaml
Dependencies:
  - equatable
Dev Dependencies:
  - async
  - convert
''');
    });

    test('passed ignores will not be reported', () {
      final result = TransitiveUseChecker(
        const TransitiveUseParams(
          path: path,
          mainIgnores: {'equatable'},
          devIgnores: {'convert'},
        ),
        logger,
      ).checkWithExit();

      expect(result, 1);
      expect(logger.warnMessage, '''
== Found undeclared/transitive packages ==
Path: $path/pubspec.yaml
Dev Dependencies:
  - async
''');
    });
  });

  group('providing no_dependencies path', () {
    test('reports no undeclared dependencies', () {
      final result = TransitiveUseChecker(
        const TransitiveUseParams(path: noDependenciesPath),
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

    test('reports no undeclared dependencies', () {
      final result = TransitiveUseChecker(
        const TransitiveUseParams(path: path),
        logger,
      ).checkWithExit();

      expect(result, 0);
      expect(logger.infoMessage, '''
All clear!
''');
    });
  });
}

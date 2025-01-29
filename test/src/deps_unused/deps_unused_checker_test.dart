import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_params.dart';
import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_status.dart';
import 'package:dart_dependency_checker_cli/src/deps_unused/deps_unused_checker.dart';
import 'package:test/test.dart';

import '../_fake_results_logger.dart';
import '../_paths.dart';

void main() {
  late FakeResultsLogger logger;

  setUp(() => logger = FakeResultsLogger());

  DepsUnusedChecker tested(DepsUnusedParams params) => DepsUnusedChecker(
        params,
        jsonOutput: false,
        logger: logger,
      );

  test('reports error on invalid pubspec.yaml path', () {
    tested(const DepsUnusedParams(path: 'unknown')).checkWithExit();

    expect(
      logger.params,
      const LogParams(
        ResultsStatus.error,
        'unknown',
        error: 'Invalid pubspec.yaml file path: unknown/pubspec.yaml',
      ),
    );
  });

  test('reports error on invalid pubspec.yaml content', () {
    tested(const DepsUnusedParams(path: emptyYamlPath)).checkWithExit();

    expect(
      logger.params,
      const LogParams(
        ResultsStatus.error,
        emptyYamlPath,
        error:
            'Invalid pubspec.yaml file contents in: $emptyYamlPath/pubspec.yaml',
      ),
    );
  });

  group('providing $allSourcesDirsPath path', () {
    const path = allSourcesDirsPath;

    test('reports only unused main and dev dependencies', () {
      tested(const DepsUnusedParams(path: path)).checkWithExit();

      expect(
        logger.params,
        const LogParams(
          ResultsStatus.warning,
          path,
          message: 'Found unused packages.',
          results: lib.DepsUnusedResults(
            mainDependencies: {'meta'},
            devDependencies: {'integration_test', 'lints'},
          ),
        ),
      );
    });

    test('passed ignores will not be reported', () {
      const params = DepsUnusedParams(
        path: path,
        devIgnores: {'integration_test'},
      );
      tested(params).checkWithExit();

      expect(
        logger.params,
        const LogParams(
          ResultsStatus.warning,
          path,
          message: 'Found unused packages.',
          results: lib.DepsUnusedResults(
            mainDependencies: {'meta'},
            devDependencies: {'lints'},
          ),
        ),
      );
    });
  });

  group('providing $noDependenciesPath path', () {
    const path = noDependenciesPath;

    test('reports no unused dependencies', () {
      tested(const DepsUnusedParams(path: path)).checkWithExit();

      expect(
        logger.params,
        const LogParams(
          ResultsStatus.clear,
          path,
          message: 'All clear!',
        ),
      );
    });
  });

  group('providing $noSourcesDirsPath path', () {
    const path = noSourcesDirsPath;

    test('reports all declared main and dev dependencies', () {
      tested(const DepsUnusedParams(path: path)).checkWithExit();

      expect(
        logger.params,
        const LogParams(
          ResultsStatus.warning,
          path,
          message: 'Found unused packages.',
          results: lib.DepsUnusedResults(
            mainDependencies: {'meta'},
            devDependencies: {'lints', 'test'},
          ),
        ),
      );
    });

    test(
        'passed ignores will not be reported '
        'even if no sources were found', () {
      tested(
        const DepsUnusedParams(path: path, devIgnores: {'lints', 'test'}),
      ).checkWithExit();

      expect(
        logger.params,
        const LogParams(
          ResultsStatus.warning,
          path,
          message: 'Found unused packages.',
          results: lib.DepsUnusedResults(
            mainDependencies: {'meta'},
            devDependencies: {},
          ),
        ),
      );
    });
  });
}

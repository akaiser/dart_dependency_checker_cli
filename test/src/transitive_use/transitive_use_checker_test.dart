import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker/src/transitive_use/transitive_use_params.dart';
import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_status.dart';
import 'package:dart_dependency_checker_cli/src/transitive_use/transitive_use_checker.dart';
import 'package:test/test.dart';

import '../_fake_results_logger.dart';
import '../_paths.dart';

void main() {
  late FakeResultsLogger logger;

  setUp(() => logger = FakeResultsLogger());

  TransitiveUseChecker tested(TransitiveUseParams params) =>
      TransitiveUseChecker(
        params,
        jsonOutput: false,
        logger: logger,
      );

  test('reports error on invalid pubspec.yaml path', () {
    tested(const TransitiveUseParams(path: 'unknown')).performWithExit();

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
    tested(const TransitiveUseParams(path: emptyYamlPath)).performWithExit();

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

  group('providing $allSourcesDirsMultiPath path', () {
    const path = allSourcesDirsMultiPath;

    test('reports only undeclared main and dev dependencies', () {
      tested(const TransitiveUseParams(path: path)).performWithExit();

      expect(
        logger.params,
        const LogParams(
          ResultsStatus.warning,
          path,
          message: 'Found undeclared/transitive packages.',
          results: lib.TransitiveUseResults(
            mainDependencies: {'equatable'},
            devDependencies: {'async', 'convert'},
          ),
        ),
      );
    });

    test('passed ignores will not be reported', () {
      const params = TransitiveUseParams(
        path: path,
        mainIgnores: {'equatable'},
        devIgnores: {'convert'},
      );
      tested(params).performWithExit();

      expect(
        logger.params,
        const LogParams(
          ResultsStatus.warning,
          path,
          message: 'Found undeclared/transitive packages.',
          results: lib.TransitiveUseResults(
            mainDependencies: {},
            devDependencies: {'async'},
          ),
        ),
      );
    });
  });

  group('providing $noDependenciesPath path', () {
    const path = noDependenciesPath;
    test('reports no undeclared dependencies', () {
      tested(const TransitiveUseParams(path: path)).performWithExit();

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

    test('reports no undeclared dependencies', () {
      tested(const TransitiveUseParams(path: path)).performWithExit();

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
}

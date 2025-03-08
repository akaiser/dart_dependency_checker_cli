import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker/src/deps_used/deps_used_params.dart';
import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_status.dart';
import 'package:dart_dependency_checker_cli/src/deps_used/deps_used_checker.dart';
import 'package:test/test.dart';

import '../_fake_results_logger.dart';
import '../_paths.dart';

void main() {
  late FakeResultsLogger logger;

  setUp(() => logger = FakeResultsLogger());

  DepsUsedChecker tested(DepsUsedParams params) => DepsUsedChecker(
        params,
        jsonOutput: false,
        logger: logger,
      );

  test('reports error on invalid pubspec.yaml path', () {
    tested(const DepsUsedParams(path: 'unknown')).performWithExit();

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
    tested(const DepsUsedParams(path: emptyYamlPath)).performWithExit();

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

  group('providing $noSourcesDirsPath path', () {
    const path = noSourcesDirsPath;

    test('reports no dependencies found', () {
      tested(const DepsUsedParams(path: path)).performWithExit();

      expect(
        logger.params,
        const LogParams(
          ResultsStatus.clear,
          path,
          message: 'No dependencies found.',
          results: lib.DepsUsedResults(
            mainDependencies: {},
            devDependencies: {},
          ),
        ),
      );
    });
  });

  group('providing $allSourcesDirsMultiPath path', () {
    const path = allSourcesDirsMultiPath;

    test('reports all dependencies', () {
      tested(const DepsUsedParams(path: path)).performWithExit();

      expect(
        logger.params,
        const LogParams(
          ResultsStatus.clear,
          path,
          message: 'Some dependencies found.',
          results: lib.DepsUsedResults(
            mainDependencies: {'args', 'equatable'},
            devDependencies: {'async', 'convert', 'test'},
          ),
        ),
      );
    });

    test('passed ignores will not be reported', () {
      const params = DepsUsedParams(
        path: path,
        mainIgnores: {'equatable'},
        devIgnores: {'convert'},
      );
      tested(params).performWithExit();

      expect(
        logger.params,
        const LogParams(
          ResultsStatus.clear,
          path,
          message: 'Some dependencies found.',
          results: lib.DepsUsedResults(
            mainDependencies: {'args'},
            devDependencies: {'async', 'test'},
          ),
        ),
      );
    });
  });
}

import 'dart:io';

import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_status.dart';
import 'package:dart_dependency_checker_cli/src/deps_sort/deps_sort_performer.dart';
import 'package:test/test.dart';

import '../_fake_results_logger.dart';
import '../_paths.dart';
import '../_util.dart';

void main() {
  late FakeResultsLogger logger;

  setUp(() => logger = FakeResultsLogger());

  DepsSortPerformer tested(lib.DepsSortParams params) => DepsSortPerformer(
        params,
        jsonOutput: false,
        logger: logger,
      );

  test('reports error on invalid pubspec.yaml path', () {
    const params = lib.DepsSortParams(path: 'unknown');

    tested(params).performWithExit();

    expect(
      logger.params,
      const LogParams(
        ResultsStatus.error,
        'unknown',
        error: 'Invalid pubspec.yaml file path: unknown/pubspec.yaml',
      ),
    );
  });

  group('providing $meantForSortingPath path', () {
    const sourcePath = meantForSortingPath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('will sort all dependencies', () {
      const params = lib.DepsSortParams(path: sourcePath);

      tested(params).performWithExit();

      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
      expect(
        logger.params,
        const LogParams(
          ResultsStatus.clear,
          sourcePath,
          message: 'Packages sorted.',
        ),
      );
    });
  });

  group('providing $meantForSortingNoNodesPath path', () {
    const sourcePath = meantForSortingNoNodesPath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('will not sort anything', () {
      const params = lib.DepsSortParams(path: sourcePath);

      tested(params).performWithExit();

      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
      expect(
        logger.params,
        const LogParams(
          ResultsStatus.warning,
          sourcePath,
          message: 'No packages sorted.',
        ),
      );
    });

    test('will not modify file', () async {
      final lastModifiedBefore = sourceFile.modified;
      const params = lib.DepsSortParams(path: sourcePath);

      tested(params).performWithExit();

      expect(lastModifiedBefore.isAtSameMomentAs(sourceFile.modified), isTrue);
    });
  });
}

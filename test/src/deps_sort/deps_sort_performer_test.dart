import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_status.dart';
import 'package:dart_dependency_checker_cli/src/deps_sort/deps_sort_performer.dart';
import 'package:test/test.dart';

import '../_fake_results_logger.dart';
import '../_file_arrange_builder.dart';
import '../_paths.dart';

void main() {
  late FakeResultsLogger logger;
  late FileArrangeBuilder builder;

  setUp(() {
    logger = FakeResultsLogger();
    builder = FileArrangeBuilder();
  });

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

    setUp(() => builder.init(sourcePath));

    tearDown(() => builder.reset());

    test('will sort all dependencies', () {
      const params = lib.DepsSortParams(path: sourcePath);

      tested(params).performWithExit();

      expect(
        logger.params,
        const LogParams(
          ResultsStatus.clear,
          sourcePath,
          message: 'Packages sorted.',
        ),
      );
      expect(builder.readFile, builder.readExpectedFile);
    });
  });

  group('providing $noNodesPath path', () {
    const sourcePath = noNodesPath;

    setUp(() => builder.init(sourcePath));

    tearDown(() => builder.reset());

    test('will not sort anything', () {
      const params = lib.DepsSortParams(path: sourcePath);

      tested(params).performWithExit();

      expect(
        logger.params,
        const LogParams(
          ResultsStatus.warning,
          sourcePath,
          message: 'No packages sorted.',
        ),
      );
      expect(builder.readFile, builder.readExpectedFile);
    });

    test('will not modify file', () async {
      const params = lib.DepsSortParams(path: sourcePath);

      tested(params).performWithExit();

      expect(
        builder.fileCreatedAt.isAtSameMomentAs(builder.fileModifiedAt),
        isTrue,
      );
    });
  });
}

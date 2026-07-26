import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';
import 'package:dart_dependency_checker_cli/src/deps_add/deps_add_performer.dart';
import 'package:test/test.dart';

import '../_fake_results_logger.dart';
import '../_file_arrange_builder.dart';
import '../_paths.dart';
import '../_util.dart';

void main() {
  late FakeResultsLogger logger;

  setUp(() => logger = FakeResultsLogger());

  DepsAddPerformer tested(lib.DepsAddParams params) =>
      DepsAddPerformer(params, jsonOutput: false, logger: logger);

  test('reports error on invalid pubspec.yaml path', () {
    const params = lib.DepsAddParams(path: 'unknown', main: {'test: 1.0.0'});

    tested(params).performWithExit();

    expect(
      logger.params,
      const LogParams(
        .error,
        'unknown',
        error: 'Invalid pubspec.yaml file path: unknown/pubspec.yaml',
      ),
    );
  });

  group('reports validation error on invalid params', () {
    test('for main dependency', () {
      const params = lib.DepsAddParams(path: 'unknown', main: {'any_main'});

      tested(params).performWithExit();

      expect(
        logger.params,
        const LogParams(
          .error,
          'unknown',
          error: 'Invalid params near: "any_main"',
        ),
      );
    });

    test('for dev dependency', () {
      const params = lib.DepsAddParams(path: 'unknown', main: {'any_dev'});

      tested(params).performWithExit();

      expect(
        logger.params,
        const LogParams(
          .error,
          'unknown',
          error: 'Invalid params near: "any_dev"',
        ),
      );
    });
  });

  group('performs', () {
    late FileArrangeBuilder builder;

    setUp(() => builder = FileArrangeBuilder());

    group('providing $noNodesPath path', () {
      const sourcePath = noNodesPath;

      setUp(() => builder.init(sourcePath));
      tearDown(() => builder.reset());

      test('will not add anything even when dependencies provided', () {
        const params = lib.DepsAddParams(
          path: sourcePath,
          main: {'equatable:^2.0.7', 'yaml: 3.1.3'},
          dev: {'test: ^1.16.0', 'build_runner: 2.4.15'},
        );

        tested(params).performWithExit();

        expect(
          logger.params,
          const LogParams(
            .warning,
            sourcePath,
            message: 'No packages added.',
            results: DepsAddResults(mainDependencies: {}, devDependencies: {}),
          ),
        );
        expect(builder.file.read, builder.expectedFile.read);
      });

      test('will not modify file', () async {
        const params = lib.DepsAddParams(
          path: sourcePath,
          main: {'equatable:^2.0.7'},
          dev: {'test: ^1.16.0'},
        );

        final result = tested(params).performWithExit();

        expect(result, 0);
        expect(
          builder.fileCreatedAt.isAtSameMomentAs(builder.fileModifiedAt),
          isTrue,
        );
      });
    });

    group('providing $meantForAddingPath path', () {
      const sourcePath = meantForAddingPath;

      setUp(() => builder.init(sourcePath));
      tearDown(() => builder.reset());

      test('will add all dependencies', () {
        const params = lib.DepsAddParams(
          path: sourcePath,
          main: {
            'equatable:^2.0.7',
            'yaml: 3.1.3',
            'some_path_source :path= ../some_path_dependency',
            'yaansi: git=https://github.com/akaiser/yaansi',
          },
          dev: {'test: ^1.16.0', 'build_runner: 2.4.15'},
        );

        tested(params).performWithExit();

        expect(
          logger.params,
          const LogParams(
            .clear,
            sourcePath,
            message: 'Packages added.',
            results: DepsAddResults(
              mainDependencies: {
                'equatable:^2.0.7',
                'yaml: 3.1.3',
                'some_path_source :path= ../some_path_dependency',
                'yaansi: git=https://github.com/akaiser/yaansi',
              },
              devDependencies: {'test: ^1.16.0', 'build_runner: 2.4.15'},
            ),
          ),
        );
        expect(builder.file.read, builder.expectedFile.read);
      });

      test('will not add anything when no dependencies provided', () {
        const params = lib.DepsAddParams(path: sourcePath, main: {}, dev: {});

        tested(params).performWithExit();

        expect(
          logger.params,
          const LogParams(
            .warning,
            sourcePath,
            message: 'No packages added.',
            results: DepsAddResults(mainDependencies: {}, devDependencies: {}),
          ),
        );
        expect(
          builder.fileCreatedAt.isAtSameMomentAs(builder.fileModifiedAt),
          isTrue,
        );
      });
    });
  });
}

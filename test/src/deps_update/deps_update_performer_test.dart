import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_status.dart';
import 'package:dart_dependency_checker_cli/src/deps_update/deps_update_performer.dart';
import 'package:test/test.dart';

import '../_fake_results_logger.dart';
import '../_file_arrange_builder.dart';
import '../_paths.dart';

void main() {
  late FakeResultsLogger logger;

  setUp(() => logger = FakeResultsLogger());

  DepsUpdatePerformer tested(lib.DepsUpdateParams params) =>
      DepsUpdatePerformer(
        params,
        jsonOutput: false,
        logger: logger,
      );

  test('reports error on invalid pubspec.yaml path', () {
    const params = lib.DepsUpdateParams(
      path: 'unknown',
      main: {'test: 1.0.0'},
    );

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

  group('reports validation error on invalid params', () {
    test('for main dependency', () {
      const params = lib.DepsUpdateParams(
        path: 'unknown',
        main: {'any_main'},
      );

      tested(params).performWithExit();

      expect(
        logger.params,
        const LogParams(
          ResultsStatus.error,
          'unknown',
          error: 'Invalid params near: "any_main"',
        ),
      );
    });

    test('for dev dependency', () {
      const params = lib.DepsUpdateParams(
        path: 'unknown',
        main: {'any_dev'},
      );

      tested(params).performWithExit();

      expect(
        logger.params,
        const LogParams(
          ResultsStatus.error,
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

      test('will not update anything even when dependencies provided', () {
        const params = lib.DepsUpdateParams(
          path: sourcePath,
          main: {'equatable:^2.0.7', 'yaml: 3.1.3'},
          dev: {'test: ^1.16.0', 'build_runner: 2.4.15'},
        );

        tested(params).performWithExit();

        expect(
          logger.params,
          const LogParams(
            ResultsStatus.warning,
            sourcePath,
            message: 'No packages updated.',
          ),
        );
        expect(builder.readFile, builder.readExpectedFile);
      });

      test('will not modify file', () async {
        const params = lib.DepsUpdateParams(
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

    group('providing $noDependenciesPath path', () {
      const sourcePath = noDependenciesPath;

      setUp(() => builder.init(sourcePath));
      tearDown(() => builder.reset());

      test('will not update anything even when dependencies provided', () {
        const params = lib.DepsUpdateParams(
          path: sourcePath,
          main: {'equatable:^2.0.7'},
          dev: {'test: ^1.16.0'},
        );

        tested(params).performWithExit();

        expect(
          logger.params,
          const LogParams(
            ResultsStatus.warning,
            sourcePath,
            message: 'No packages updated.',
          ),
        );
        expect(builder.readFile, builder.readExpectedFile);
      });

      test('will not modify file', () async {
        const params = lib.DepsUpdateParams(
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

    group('providing $meantForUpdatingPath path', () {
      const sourcePath = meantForUpdatingPath;

      setUp(() => builder.init(sourcePath));
      tearDown(() => builder.reset());

      test('will not modify file on not matching deps', () async {
        const params = lib.DepsUpdateParams(
          path: sourcePath,
          main: {'equatable:^2.0.7'},
        );

        final result = tested(params).performWithExit();

        expect(result, 0);
        expect(
          logger.params,
          const LogParams(
            ResultsStatus.warning,
            sourcePath,
            message: 'No packages updated.',
          ),
        );
        expect(
          builder.fileCreatedAt.isAtSameMomentAs(builder.fileModifiedAt),
          isTrue,
        );
      });

      test('will update all matching dependencies', () async {
        const params = lib.DepsUpdateParams(
          path: sourcePath,
          main: {
            'args:^2.7.0',
            'equatable:^2.0.7',
            'some_path_source : path= ../some_path_dependency/new',
            'some: git= https://any.git; ref=main',
          },
          dev: {'test: ^1.26.3'},
        );

        final result = tested(params).performWithExit();

        expect(result, 0);
        expect(
          logger.params,
          const LogParams(
            ResultsStatus.clear,
            sourcePath,
            message: 'Packages updated.',
          ),
        );
        expect(builder.readFile, builder.readExpectedFile);
      });
    });
  });
}

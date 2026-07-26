import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';
import 'package:dart_dependency_checker_cli/src/deps_unused/deps_unused_checker.dart';
import 'package:test/test.dart';

import '../_fake_results_logger.dart';
import '../_file_arrange_builder.dart';
import '../_paths.dart';
import '../_util.dart';

void main() {
  late FakeResultsLogger logger;
  late FileArrangeBuilder builder;

  setUp(() {
    logger = FakeResultsLogger();
    builder = FileArrangeBuilder();
  });

  DepsUnusedChecker tested(lib.DepsUnusedParams params) =>
      DepsUnusedChecker(params, jsonOutput: false, logger: logger);

  test('reports error on invalid pubspec.yaml path', () {
    tested(const lib.DepsUnusedParams(path: 'unknown')).performWithExit();

    expect(
      logger.params,
      const LogParams(
        .error,
        'unknown',
        error: 'Invalid pubspec.yaml file path: unknown/pubspec.yaml',
      ),
    );
  });

  test('reports error on invalid pubspec.yaml content', () {
    tested(const lib.DepsUnusedParams(path: emptyYamlPath)).performWithExit();

    expect(
      logger.params,
      const LogParams(
        .error,
        emptyYamlPath,
        error:
            'Invalid pubspec.yaml file contents in: $emptyYamlPath/pubspec.yaml',
      ),
    );
  });

  group('providing $allSourcesDirsPath path', () {
    const path = allSourcesDirsPath;

    test('reports only unused main and dev dependencies', () {
      tested(const lib.DepsUnusedParams(path: path)).performWithExit();

      expect(
        logger.params,
        const LogParams(
          .warning,
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
      const params = lib.DepsUnusedParams(
        path: path,
        devIgnores: {'integration_test'},
      );
      tested(params).performWithExit();

      expect(
        logger.params,
        const LogParams(
          .warning,
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
      tested(const lib.DepsUnusedParams(path: path)).performWithExit();

      expect(
        logger.params,
        const LogParams(.clear, path, message: 'All clear!'),
      );
    });
  });

  group('providing $noSourcesDirsPath path', () {
    const path = noSourcesDirsPath;

    test('reports all declared main and dev dependencies', () {
      tested(const lib.DepsUnusedParams(path: path)).performWithExit();

      expect(
        logger.params,
        const LogParams(
          .warning,
          path,
          message: 'Found unused packages.',
          results: lib.DepsUnusedResults(
            mainDependencies: {'meta'},
            devDependencies: {'lints', 'test'},
          ),
        ),
      );
    });

    test('passed ignores will not be reported '
        'even if no sources were found', () {
      const params = lib.DepsUnusedParams(
        path: path,
        devIgnores: {'lints', 'test'},
      );

      tested(params).performWithExit();

      expect(
        logger.params,
        const LogParams(
          .warning,
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

  group('with "fix" flag', () {
    tearDown(() => builder.reset());

    group('providing $meantForFixingPath path', () {
      const sourcePath = meantForFixingPath;

      setUp(() => builder.init(sourcePath));

      test('cleanes source file', () {
        const params = lib.DepsUnusedParams(
          path: sourcePath,
          mainIgnores: {'args', 'some_hosted_source', 'bla_support'},
          devIgnores: {
            'flutter_test',
            'bla_dart_lints',
            'test',
            'bla_other_bed',
          },
          fix: true,
        );

        tested(params).performWithExit();

        expect(
          logger.params,
          const LogParams(
            .clear,
            sourcePath,
            message: 'Removed unused packages.',
            results: lib.DepsUnusedResults(
              mainDependencies: {'meta', 'bla_analytics'},
              devDependencies: {'integration_test', 'lints', 'bla_test_bed'},
            ),
          ),
        );
        expect(builder.file.read, builder.expectedFile.read);
      });

      test('leaves blank dependency sections', () {
        const params = lib.DepsUnusedParams(
          path: sourcePath,
          mainIgnores: {},
          devIgnores: {},
          fix: true,
        );

        tested(params).performWithExit();

        expect(
          builder.file.read,
          '$sourcePath/expected_empty_dependencies.yaml'.file.read,
        );
      });
    });

    group('providing $noNodesPath path', () {
      const sourcePath = noNodesPath;

      setUp(() => builder.init(sourcePath));

      test('passes with no changes', () {
        const params = lib.DepsUnusedParams(
          path: sourcePath,
          mainIgnores: {},
          devIgnores: {},
          fix: true,
        );

        tested(params).performWithExit();

        expect(
          logger.params,
          const LogParams(.clear, sourcePath, message: 'All clear!'),
        );
        expect(builder.file.read, builder.expectedFile.read);
      });
    });
  });
}

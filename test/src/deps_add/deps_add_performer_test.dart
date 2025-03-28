import 'dart:io';

import 'package:dart_dependency_checker/dart_dependency_checker.dart' as lib;
import 'package:dart_dependency_checker_cli/src/_logger/log_params.dart';
import 'package:dart_dependency_checker_cli/src/_logger/results_status.dart';
import 'package:dart_dependency_checker_cli/src/deps_add/deps_add_performer.dart';
import 'package:test/test.dart';

import '../_fake_results_logger.dart';
import '../_paths.dart';
import '../_util.dart';

void main() {
  late FakeResultsLogger logger;

  setUp(() => logger = FakeResultsLogger());

  DepsAddPerformer tested(lib.DepsAddParams params) => DepsAddPerformer(
        params,
        jsonOutput: false,
        logger: logger,
      );

  test('reports error on invalid pubspec.yaml path', () {
    const params = lib.DepsAddParams(path: 'unknown');

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

  group('providing $meantForAddingPath path', () {
    const sourcePath = meantForAddingPath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('will add all dependencies', () {
      const params = lib.DepsAddParams(
        path: sourcePath,
        main: {
          'equatable:^2.0.7',
          'yaml: 3.1.3',
          'some_path_source :path= ../some_path_dependency',
          'some_git_source: git=https://github.com/munificent/kittens.git',
        },
        dev: {
          'test: ^1.16.0',
          'build_runner: 2.4.15',
        },
      );

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
          message: 'Packages added.',
          results: DepsAddResults(
            mainDependencies: {
              'equatable:^2.0.7',
              'yaml: 3.1.3',
              'some_path_source :path= ../some_path_dependency',
              'some_git_source: git=https://github.com/munificent/kittens.git',
            },
            devDependencies: {
              'test: ^1.16.0',
              'build_runner: 2.4.15',
            },
          ),
        ),
      );
    });

    test('will not add anything when no dependencies provided', () {
      const params = lib.DepsAddParams(
        path: sourcePath,
        main: {},
        dev: {},
      );

      tested(params).performWithExit();

      expect(
        logger.params,
        const LogParams(
          ResultsStatus.warning,
          sourcePath,
          message: 'No packages added.',
          results: DepsAddResults(
            mainDependencies: {},
            devDependencies: {},
          ),
        ),
      );
    });
  });

  group('providing $meantForAddingNoNodesPath path', () {
    const sourcePath = meantForAddingNoNodesPath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('will not add anything even when dependencies provided', () {
      const params = lib.DepsAddParams(
        path: sourcePath,
        main: {'equatable:^2.0.7', 'yaml: 3.1.3'},
        dev: {'test: ^1.16.0', 'build_runner: 2.4.15'},
      );

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
          message: 'No packages added.',
          results: DepsAddResults(
            mainDependencies: {},
            devDependencies: {},
          ),
        ),
      );
    });

    test('will not modify file', () async {
      final lastModifiedBefore = sourceFile.modified;
      const params = lib.DepsAddParams(
        path: sourcePath,
        main: {'equatable:^2.0.7'},
        dev: {'test: ^1.16.0'},
      );

      tested(params).performWithExit();

      expect(lastModifiedBefore.isAtSameMomentAs(sourceFile.modified), isTrue);
    });
  });
}

import 'package:dart_dependency_checker_cli/src/deps_unused/deps_unused_command.dart';
import 'package:test/test.dart';

void main() {
  test('has expected name', () {
    expect(
      DepsUnusedCommand().name,
      'deps-unused',
    );
  });

  test('has expected description', () {
    expect(
      DepsUnusedCommand().description,
      'Checks and fixes unused dependencies.',
    );
  });

  group('arg parser', () {
    test('has all expected options', () {
      expect(
        DepsUnusedCommand().argParser.options.keys,
        ['help', 'path', 'dev-ignores', 'main-ignores', 'fix'],
      );
    });

    test('parses -h', () {
      expect(
        DepsUnusedCommand().argParser.parse(['-h']).wasParsed('help'),
        isTrue,
      );
    });

    test('parses -p', () {
      expect(
        DepsUnusedCommand().argParser.parse(['-p', '.']).wasParsed('path'),
        isTrue,
      );
    });

    test('explodes on missing -p value', () {
      expect(
        () => DepsUnusedCommand().argParser.parse(['-p']),
        throwsA(
          isA<FormatException>().having(
            (exception) => exception.message,
            'message',
            'Missing argument for "path".',
          ),
        ),
      );
    });

    test('parses --dev-ignores', () {
      expect(
        DepsUnusedCommand()
            .argParser
            .parse(['--dev-ignores', 'meta']).wasParsed('dev-ignores'),
        isTrue,
      );
    });

    test('explodes on missing --dev-ignores value', () {
      expect(
        () => DepsUnusedCommand().argParser.parse(['--dev-ignores']),
        throwsA(
          isA<FormatException>().having(
            (exception) => exception.message,
            'message',
            'Missing argument for "dev-ignores".',
          ),
        ),
      );
    });

    test('parses --main-ignores', () {
      expect(
        DepsUnusedCommand()
            .argParser
            .parse(['--main-ignores', 'meta']).wasParsed('main-ignores'),
        isTrue,
      );
    });

    test('explodes on missing --main-ignores value', () {
      expect(
        () => DepsUnusedCommand().argParser.parse(['--main-ignores']),
        throwsA(
          isA<FormatException>().having(
            (exception) => exception.message,
            'message',
            'Missing argument for "main-ignores".',
          ),
        ),
      );
    });

    test('parses --fix', () {
      expect(
        DepsUnusedCommand().argParser.parse(['--fix']).wasParsed('fix'),
        isTrue,
      );
    });
  });
}

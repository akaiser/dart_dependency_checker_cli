import 'package:dart_dependency_checker_cli/src/deps_sort/deps_sort_command.dart';
import 'package:test/test.dart';

void main() {
  final tested = DepsSortCommand();

  test('has expected name', () {
    expect(tested.name, 'deps-sort');
  });

  test('has expected aliases', () {
    expect(tested.aliases, const ['ds']);
  });

  test('has expected description', () {
    expect(
      tested.description,
      'Sorts main and dev dependencies in a pubspec.yaml file.',
    );
  });

  group('arg parser', () {
    final argParser = tested.argParser;

    test('has all expected options', () {
      expect(
        argParser.options.keys,
        const ['help', 'path', 'json'],
      );
    });

    test('explodes on unknown flag', () {
      expect(
        () => argParser.parse(const {'-g'}),
        throwsA(
          isA<FormatException>().having(
            (exception) => exception.message,
            'message',
            'Could not find an option or flag "-g".',
          ),
        ),
      );
    });

    group('help', () {
      test('not parsing -h when not provided', () {
        expect(
          argParser.parse(const {}).wasParsed('help'),
          isFalse,
        );
      });

      test('parses -h', () {
        expect(
          argParser.parse(const {'-h'}).wasParsed('help'),
          isTrue,
        );
      });
    });

    group('path', () {
      test('not parsing -p when not provided', () {
        expect(
          argParser.parse(const {}).wasParsed('path'),
          isFalse,
        );
      });

      test('explodes on missing -p value', () {
        expect(
          () => argParser.parse(const {'-p'}),
          throwsA(
            isA<FormatException>().having(
              (exception) => exception.message,
              'message',
              'Missing argument for "-p".',
            ),
          ),
        );
      });

      test('parses -p value', () {
        expect(
          argParser.parse(const {'-p', 'some/path'})['path'],
          'some/path',
        );
      });

      test('explodes on missing --path value', () {
        expect(
          () => argParser.parse(const {'--path'}),
          throwsA(
            isA<FormatException>().having(
              (exception) => exception.message,
              'message',
              'Missing argument for "--path".',
            ),
          ),
        );
      });

      test('parses --path value', () {
        expect(
          argParser.parse(const {'--path=some/path'})['path'],
          'some/path',
        );
      });
    });

    group('json', () {
      test('not parsing --json when not provided', () {
        expect(
          argParser.parse(const {}).wasParsed('json'),
          isFalse,
        );
      });

      test('parses --json as true value', () {
        expect(
          argParser.parse(const {'--json'})['json'],
          isTrue,
        );
      });

      test('parses --no-json as false value', () {
        expect(
          argParser.parse(const {'--no-json'})['json'],
          isFalse,
        );
      });
    });
  });
}

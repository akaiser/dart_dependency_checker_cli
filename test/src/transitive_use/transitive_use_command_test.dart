import 'package:dart_dependency_checker_cli/src/transitive_use/transitive_use_command.dart';
import 'package:test/test.dart';

void main() {
  final tested = TransitiveUseCommand();

  test('has expected name', () {
    expect(tested.name, 'transitive-use');
  });

  test('has expected description', () {
    expect(
      tested.description,
      'Checks direct use of undeclared/transitive dependencies',
    );
  });

  group('arg parser', () {
    final argParser = tested.argParser;

    test('has all expected options', () {
      expect(
        argParser.options.keys,
        const ['help', 'path', 'main-ignores', 'dev-ignores', 'json'],
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
              'Missing argument for "path".',
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
              'Missing argument for "path".',
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

    group('main-ignores', () {
      test('not parsing --main-ignores when not provided', () {
        expect(
          argParser.parse(const {}).wasParsed('main-ignores'),
          isFalse,
        );
      });

      test('explodes on missing --main-ignores value', () {
        expect(
          () => argParser.parse(const {'--main-ignores'}),
          throwsA(
            isA<FormatException>().having(
              (exception) => exception.message,
              'message',
              'Missing argument for "main-ignores".',
            ),
          ),
        );
      });

      test('parses --main-ignores values', () {
        expect(
          argParser.parse(const {'--main-ignores', 'a,b'})['main-ignores'],
          const ['a', 'b'],
        );
      });
    });

    group('dev-ignores', () {
      test('not parsing --dev-ignores when not provided', () {
        expect(
          argParser.parse(const {}).wasParsed('dev-ignores'),
          isFalse,
        );
      });

      test('explodes on missing --dev-ignores value', () {
        expect(
          () => argParser.parse(const {'--dev-ignores'}),
          throwsA(
            isA<FormatException>().having(
              (exception) => exception.message,
              'message',
              'Missing argument for "dev-ignores".',
            ),
          ),
        );
      });

      test('parses --dev-ignores values', () {
        expect(
          argParser.parse(const {'--dev-ignores', 'a,b'})['dev-ignores'],
          const ['a', 'b'],
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

import 'package:dart_dependency_checker_cli/src/deps_add/deps_add_command.dart';
import 'package:test/test.dart';

void main() {
  final tested = DepsAddCommand();

  test('has expected name', () {
    expect(tested.name, 'deps-add');
  });

  test('has expected aliases', () {
    expect(tested.aliases, const ['da']);
  });

  test('has expected description', () {
    expect(
      tested.description,
      'Adds main and dev dependencies to a pubspec.yaml file.',
    );
  });

  group('arg parser', () {
    final argParser = tested.argParser;

    test('has all expected options', () {
      expect(
        argParser.options.keys,
        const ['help', 'path', 'main', 'dev', 'json'],
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

    group('main', () {
      test('not parsing --main when not provided', () {
        expect(
          argParser.parse(const {}).wasParsed('main'),
          isFalse,
        );
      });

      test('explodes on missing --main value', () {
        expect(
          () => argParser.parse(const {'--main'}),
          throwsA(
            isA<FormatException>().having(
              (exception) => exception.message,
              'message',
              'Missing argument for "--main".',
            ),
          ),
        );
      });

      test('parses --main values', () {
        expect(
          argParser.parse(const {'--main', 'a,b'})['main'],
          const ['a', 'b'],
        );
      });

      group('m alias', () {
        test('explodes on missing --m value', () {
          expect(
            () => argParser.parse(const {'--m'}),
            throwsA(
              isA<FormatException>().having(
                (exception) => exception.message,
                'message',
                'Missing argument for "--m".',
              ),
            ),
          );
        });

        test('parses --m values', () {
          expect(
            argParser.parse(const {'--m', 'a,b'})['main'],
            const ['a', 'b'],
          );
        });
      });
    });

    group('dev', () {
      test('not parsing --dev when not provided', () {
        expect(
          argParser.parse(const {}).wasParsed('dev'),
          isFalse,
        );
      });

      test('explodes on missing --dev value', () {
        expect(
          () => argParser.parse(const {'--dev'}),
          throwsA(
            isA<FormatException>().having(
              (exception) => exception.message,
              'message',
              'Missing argument for "--dev".',
            ),
          ),
        );
      });

      test('parses --dev values', () {
        expect(
          argParser.parse(const {'--dev', 'a,b'})['dev'],
          const ['a', 'b'],
        );
      });

      group('d alias', () {
        test('explodes on missing --d value', () {
          expect(
            () => argParser.parse(const {'--d'}),
            throwsA(
              isA<FormatException>().having(
                (exception) => exception.message,
                'message',
                'Missing argument for "--d".',
              ),
            ),
          );
        });

        test('parses --d values', () {
          expect(
            argParser.parse(const {'--d', 'a,b'})['dev'],
            const ['a', 'b'],
          );
        });
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

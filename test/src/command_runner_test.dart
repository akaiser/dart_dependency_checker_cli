import 'package:dart_dependency_checker_cli/src/command_runner.dart';
import 'package:test/test.dart';

void main() {
  final tested = CommandRunner();

  test('has expected executableName', () {
    expect(tested.executableName, 'ddc');
  });

  test('has expected description', () {
    expect(
      tested.description,
      'A utility package for checking dependencies within Dart/Flutter packages.',
    );
  });

  group('arg parser', () {
    final argParser = tested.argParser;

    test('has all expected options', () {
      expect(
        argParser.options.keys,
        ['help', 'version'],
      );
    });

    test('has all expected commands', () {
      expect(
        argParser.commands.keys,
        ['help', 'deps-unused'],
      );
    });

    test('explodes on unknown flag', () {
      expect(
        () => argParser.parse(['-g']),
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
          argParser.parse(const []).wasParsed('help'),
          isFalse,
        );
      });

      test('parses -h', () {
        expect(
          argParser.parse(['-h']).wasParsed('help'),
          isTrue,
        );
      });
    });

    group('version', () {
      test('not parsing --version when not provided', () {
        expect(
          argParser.parse(const []).wasParsed('version'),
          isFalse,
        );
      });

      test('parses --version', () {
        expect(
          argParser.parse(['--version']).wasParsed('version'),
          isTrue,
        );
      });
    });
  });
}

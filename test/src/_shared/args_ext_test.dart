import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_dependency_checker_cli/src/_shared/args_ext.dart';
import 'package:test/test.dart';

void main() {
  group('ArgParserExt', () {
    test('withPathOption', () {
      final tested = ArgParser()..withPathOption;

      expect(
        tested.options['path'],
        isA<Option>()
            .having((o) => o.isSingle, 'isSingle', isTrue)
            .having((o) => o.abbr, 'abbr', 'p')
            .having((o) => o.valueHelp, 'valueHelp', 'path')
            .having((o) => o.help, 'help', 'Path to valid pubspec.yaml.'),
      );
    });

    test('withMainIgnoresMultiOption', () {
      final tested = ArgParser()..withMainIgnoresMultiOption;

      expect(
        tested.options['main-ignores'],
        isA<Option>()
            .having((o) => o.isMultiple, 'isMultiple', isTrue)
            .having((o) => o.abbr, 'abbr', isNull)
            .having((o) => o.valueHelp, 'valueHelp', isNull)
            .having(
              (o) => o.help,
              'help',
              'Comma separated list of main dependencies to be ignored.',
            ),
      );
    });

    test('withDevIgnoresMultiOption', () {
      final tested = ArgParser()..withDevIgnoresMultiOption;

      expect(
        tested.options['dev-ignores'],
        isA<Option>()
            .having((o) => o.isMultiple, 'isMultiple', isTrue)
            .having((o) => o.abbr, 'abbr', isNull)
            .having((o) => o.valueHelp, 'valueHelp', isNull)
            .having(
              (o) => o.help,
              'help',
              'Comma separated list of dev dependencies to be ignored.',
            ),
      );
    });

    test('withFixFlag', () {
      final tested = ArgParser()..withFixFlag;

      expect(
        tested.options['fix'],
        isA<Option>()
            .having((o) => o.isFlag, 'isFlag', isTrue)
            .having((o) => o.abbr, 'abbr', isNull)
            .having((o) => o.valueHelp, 'valueHelp', isNull)
            .having(
              (o) => o.help,
              'help',
              'Instant cleanup after checker run.',
            ),
      );
    });

    test('withJsonFlag', () {
      final tested = ArgParser()..withJsonFlag;

      expect(
        tested.options['json'],
        isA<Option>()
            .having((o) => o.isFlag, 'isFlag', isTrue)
            .having((o) => o.abbr, 'abbr', isNull)
            .having((o) => o.valueHelp, 'valueHelp', isNull)
            .having((o) => o.help, 'help', 'Output in json format.'),
      );
    });
  });

  group('ArgResultsExt', () {
    group('path', () {
      final parser = ArgParser()..withPathOption;

      test('resolves to ${Directory.current.path} on null $ArgResults', () {
        expect(null.path, Directory.current.path);
      });

      test('resolves to ${Directory.current.path} when no path arg parsed', () {
        final tested = (parser).parse(const {});

        expect(tested.path, Directory.current.path);
      });

      test('resolves to provided -p value', () {
        final tested = (parser).parse(const {'-p', 'some/path'});

        expect(tested.path, 'some/path');
      });

      test('resolves to provided --path value', () {
        final tested = (parser).parse(const {'--path=some/path'});

        expect(tested.path, 'some/path');
      });
    });

    group('main', () {
      final parser = ArgParser()..withMainMultiOption;

      test('resolves to empty on null $ArgResults', () {
        expect(null.main, const <String>{});
      });

      test('resolves to empty when no --main arg parsed', () {
        final tested = (parser).parse(const {});

        expect(tested.main, const <String>{});
      });

      test('resolves to provided --main values', () {
        final tested = (parser).parse(const {'--main', 'a,b,c'});

        expect(tested.main, const {'a', 'b', 'c'});
      });
    });

    group('dev', () {
      final parser = ArgParser()..withDevMultiOption;

      test('resolves to empty on null $ArgResults', () {
        expect(null.dev, const <String>{});
      });

      test('resolves to empty when no --dev arg parsed', () {
        final tested = (parser).parse(const {});

        expect(tested.dev, const <String>{});
      });

      test('resolves to provided --dev values', () {
        final tested = (parser).parse(const {'--dev', 'a,b,c'});

        expect(tested.dev, const {'a', 'b', 'c'});
      });
    });

    group('mainIgnores', () {
      final parser = ArgParser()..withMainIgnoresMultiOption;

      test('resolves to empty on null $ArgResults', () {
        expect(null.mainIgnores, const <String>{});
      });

      test('resolves to empty when no --main-ignores arg parsed', () {
        final tested = (parser).parse(const {});

        expect(tested.mainIgnores, const <String>{});
      });

      test('resolves to provided --main-ignores values', () {
        final tested = (parser).parse(const {'--main-ignores', 'a,b,c'});

        expect(tested.mainIgnores, const {'a', 'b', 'c'});
      });
    });

    group('devIgnores', () {
      final parser = ArgParser()..withDevIgnoresMultiOption;

      test('resolves to empty on null $ArgResults', () {
        expect(null.devIgnores, const <String>{});
      });

      test('resolves to empty when no --dev-ignores arg parsed', () {
        final tested = (parser).parse(const {});

        expect(tested.devIgnores, const <String>{});
      });

      test('resolves to provided --dev-ignores values', () {
        final tested = (parser).parse(const {'--dev-ignores', 'a,b,c'});

        expect(tested.devIgnores, const {'a', 'b', 'c'});
      });
    });

    group('fix', () {
      final parser = ArgParser()..withFixFlag;

      test('resolves to false on null $ArgResults', () {
        expect(null.fix, isFalse);
      });

      test('resolves to false when no --fix flag parsed', () {
        final tested = (parser).parse(const {});

        expect(tested.fix, isFalse);
      });

      test('resolves to true if --fix flag provided', () {
        final tested = (parser).parse(const {'--fix'});

        expect(tested.fix, isTrue);
      });

      test('resolves to false if --no-fix flag provided', () {
        final tested = (parser).parse(const {'--no-fix'});

        expect(tested.fix, isFalse);
      });
    });

    group('json', () {
      final parser = ArgParser()..withJsonFlag;

      test('resolves to false on null $ArgResults', () {
        expect(null.json, isFalse);
      });

      test('resolves to false when no --json flag parsed', () {
        final tested = (parser).parse(const {});

        expect(tested.json, isFalse);
      });

      test('resolves to true if --json flag provided', () {
        final tested = (parser).parse(const {'--json'});

        expect(tested.json, isTrue);
      });

      test('resolves to false if --no-json flag provided', () {
        final tested = (parser).parse(const {'--no-json'});

        expect(tested.json, isFalse);
      });
    });
  });
}

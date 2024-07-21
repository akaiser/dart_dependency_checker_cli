import 'package:dart_dependency_checker_cli/src/_shared/iterable_ext.dart';
import 'package:test/test.dart';

void main() {
  group('unmodifiable', () {
    final tested = const [1, 2, 3].unmodifiable;

    test('creates list', () {
      expect(tested, isA<List<int>>());
    });

    test('equals', () {
      expect(tested, equals(const [1, 2, 3]));
    });

    test('is not same', () {
      expect(tested, isNot(same(const [1, 2, 3])));
    });

    test('throws on add', () {
      expect(() => tested.add(0), throwsUnsupportedError);
    });

    test('throws on remove', () {
      expect(() => tested.remove(0), throwsUnsupportedError);
    });
  });
}

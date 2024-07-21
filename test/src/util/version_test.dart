import 'package:dart_dependency_checker_cli/src/util/version.dart';
import 'package:test/test.dart';

void main() {
  test('has expected packageVersion', () {
    expect(packageVersion, '0.2.1');
  });
}

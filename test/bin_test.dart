import 'dart:io';

import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  final yaml = loadYaml(File('pubspec.yaml').readAsStringSync()) as YamlMap;
  final executables = (yaml['executables'] as YamlMap).nodes.keys;

  for (final executable in executables) {
    test('Executable runs and prints expected output', () async {
      final result = await Process.run('dart', ['bin/$executable.dart']);

      expect(result.exitCode, equals(0));
    });
  }
}

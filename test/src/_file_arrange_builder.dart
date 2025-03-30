import 'dart:io';

import '_util.dart';

class FileArrangeBuilder {
  late final File file;
  late final String _initContent;
  late final DateTime fileCreatedAt;

  late final File _expectedFile;

  void init(String path) {
    file = File('$path/pubspec.yaml');
    _initContent = file.read;
    fileCreatedAt = file.modified;

    _expectedFile = File('$path/expected.yaml');
  }

  DateTime get fileModifiedAt => file.modified;

  String get readFile => file.read;

  String get readExpectedFile => _expectedFile.read;

  void reset() => file.writeAsStringSync(_initContent);
}

extension on File {
  DateTime get modified => statSync().modified;
}

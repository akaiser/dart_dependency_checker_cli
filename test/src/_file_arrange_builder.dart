import 'dart:io';

import '_util.dart';

class FileArrangeBuilder {
  late final File file;
  late final String _initContent;
  late final DateTime fileCreatedAt;

  late final File expectedFile;

  void init(String path) {
    file = '$path/pubspec.yaml'.file;
    _initContent = file.read;
    fileCreatedAt = file.modified;

    expectedFile = '$path/expected.yaml'.file;
  }

  DateTime get fileModifiedAt => file.modified;

  void reset() => file.writeAsStringSync(_initContent);
}

extension on File {
  DateTime get modified => statSync().modified;
}

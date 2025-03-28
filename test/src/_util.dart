import 'dart:io';

extension FileExt on File {
  String get read => readAsStringSync();

  DateTime get modified => statSync().modified;
}

extension StringExt on String {
  String get read => File(this).read;
}

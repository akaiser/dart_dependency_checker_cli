import 'dart:io';

extension FileExt on File {
  String get read => readAsStringSync();
}

extension StringExt on String {
  String get read => File(this).read;
}

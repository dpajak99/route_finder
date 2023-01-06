import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {
    static Future<String> readLocalFile(String filename) async {
    try {
      final File file = await getLocalFile(filename);
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      rethrow;
    }
  }

  static Future<File> writeLocalFile(String filename, String contents) async {
    final File file = await getLocalFile(filename);
    return file.writeAsString(contents);
  }

  static Future<File> getLocalFile(String filename) async {
    final String path = await _getLocalPath();
    return File('$path/$filename');
  }

  static Future<String> _getLocalPath() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  
  static Future<String> readAssetFile(String filename) async {
    try {
      String contents = await rootBundle.loadString('assets/$filename');
      return contents;
    } catch (e) {
      rethrow;
    }
  }
}
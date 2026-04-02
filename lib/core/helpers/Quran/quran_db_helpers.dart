import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class QuranDbHelper {
  static Future<Database> loadDatabase(String assetPath, String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    // check if already exists
    if (!await File(path).exists()) {
      // copy from assets
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();

      await File(path).writeAsBytes(bytes, flush: true);
    }

    return openDatabase(path);
  }
}

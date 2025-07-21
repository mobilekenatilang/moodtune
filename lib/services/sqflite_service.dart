import 'dart:async';

import 'package:moodtune/services/logger_service.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteService {
  static Database? _database;

  static Future<void> init() async {
    LoggerService.i('Initializing Sqflite Database Service');
    _database = await openDatabase(
      join(await getDatabasesPath(), 'moodtune_journal.db'),
      onCreate: (db, version) {
        return db.execute(rawSQL);
      },
      version: 1,
    );
    LoggerService.i(
      'Sqflite Database Service initialized, File location: ${_database!.path}',
    );
  }

  static Future<List<Map<String, dynamic>>> raw(String query) async {
    return await _database!.rawQuery(query);
  }

  static Future<List<Map<String, dynamic>>> getAll(String table) async {
    return await _database!.query(table);
  }

  static Future<int> count(String table) async {
    final result = await _database!.rawQuery('SELECT COUNT(*) FROM $table');
    if (result.isNotEmpty) {
      return Sqflite.firstIntValue(result) ?? 0;
    } else {
      return 0;
    }
  }

  static Future<List<Map<String, dynamic>>> query(
    String table,
    String query,
  ) async {
    return await _database!.rawQuery('SELECT * FROM $table WHERE $query');
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    await _database!.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> update(
    String table,
    Map<String, dynamic> data,
    String where,
  ) async {
    await _database!.update(table, data, where: where);
  }

  static Future<void> delete(String table, String where) async {
    await _database!.delete(table, where: where);
  }
}

final String rawSQL = '''
CREATE TABLE journal(
  timestamp TEXT PRIMARY KEY,
  title TEXT,
  content TEXT,
  mood TEXT,
  advice TEXT,
  playlist TEXT -- Aslinya JSON string of playlist
)
''';

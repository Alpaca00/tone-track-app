import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'sentiment_service.dart';
import '../models/entry.dart';
import '../models/mood.dart';

class DatabaseService {
  static const String _dbName = 'entries.db';
  static const int _dbVersion = 1;
  static const String _tableName = 'entries';

  Database? _database;

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            note TEXT,
            date TEXT,
            mood TEXT
          )
        ''');
      },
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> saveEntry(Entry entry) async {
    final db = await database;

    SentimentService sentimentService = SentimentService();
    Mood mood = await sentimentService.analyzeMood(entry.note);

    await db.insert(
      _tableName,
      {
        'id': entry.id,
        'note': entry.note,
        'date': entry.date.toIso8601String(),
        'mood': mood.name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Entry>> getEntries() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List<Entry>.generate(maps.length, (i) {
      return Entry(
        id: maps[i]['id'] as String,
        note: maps[i]['note'] as String,
        date: DateTime.parse(maps[i]['date'] as String),
        mood: Mood.values.firstWhere((m) => m.name == maps[i]['mood']),
      );
    });
  }

  Future<void> deleteEntry(String id) async {
    final db = await database;

    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}

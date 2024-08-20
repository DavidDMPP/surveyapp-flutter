import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/survey.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('surveys.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE surveys(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        name TEXT,
        photoPath TEXT,
        latitude REAL,
        longitude REAL,
        isSynced INTEGER
      )
    ''');
  }

  Future<int> insertSurvey(Survey survey, int userId) async {
    final db = await instance.database;
    final data = survey.toJson();
    data['userId'] = userId;
    data['isSynced'] = 0;
    return await db.insert('surveys', data);
  }

  Future<List<Survey>> getSurveys(int userId) async {
    final db = await instance.database;
    final result = await db.query('surveys', where: 'userId = ?', whereArgs: [userId]);
    return result.map((json) => Survey.fromJson(json)).toList();
  }

  Future<int> getUnsyncedSurveysCount(int userId) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM surveys WHERE userId = ? AND isSynced = 0',
      [userId]
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Survey>> getUnsyncedSurveys(int userId) async {
    final db = await instance.database;
    final result = await db.query(
      'surveys',
      where: 'userId = ? AND isSynced = 0',
      whereArgs: [userId]
    );
    return result.map((json) => Survey.fromJson(json)).toList();
  }

  Future<void> markSurveyAsSynced(int id) async {
    final db = await instance.database;
    await db.update(
      'surveys',
      {'isSynced': 1},
      where: 'id = ?',
      whereArgs: [id]
    );
  }
}
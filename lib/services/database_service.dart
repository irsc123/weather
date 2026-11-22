import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class DatabaseService {
  static Database? _database;
  static const String _dbName = 'weather_notes.db';
  static const int _dbVersion = 1;
  static const String _tableName = 'notes';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    final map = note.toMap()..remove('id');
    return db.insert(_tableName, map);
  }

  Future<List<Note>> fetchNotes() async {
    final db = await database;
    final maps = await db.query(_tableName, orderBy: 'updated_at DESC');
    return maps.map((m) => Note.fromMap(m)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    final map = note.toMap()..remove('id');
    return db.update(_tableName, map, where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
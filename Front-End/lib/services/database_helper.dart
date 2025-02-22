import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'users_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        fullName TEXT,
        email TEXT,
        phone TEXT,
        city TEXT,
        profileImage TEXT
      )
    ''');
  }

  Future<bool> insertUser(User user) async {
    final db = await database;
    try {
      await db.insert('users', user.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<User>> getUsers({String? search}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;
    
    if (search != null && search.isNotEmpty) {
      maps = await db.query('users',
          where: 'fullName LIKE ? OR email LIKE ? OR city LIKE ?',
          whereArgs: ['%$search%', '%$search%', '%$search%']);
    } else {
      maps = await db.query('users');
    }

    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        fullName: maps[i]['fullName'],
        email: maps[i]['email'],
        phone: maps[i]['phone'],
        city: maps[i]['city'],
        profileImage: maps[i]['profileImage'],
      );
    });
  }
}
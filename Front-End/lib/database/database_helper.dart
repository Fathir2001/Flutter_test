import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fullName TEXT,
            city TEXT,
            email TEXT,
            phone TEXT,
            profileImage TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertUser(UserModel user) async {
    final db = await database;
    int result = await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore, // Prevents duplicate inserts
    );

    print("User Inserted: ${user.fullName}, Insert Result: $result");
  }

  Future<List<UserModel>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    print("Fetched Users from DB: $maps"); // Debug log

    return List.generate(maps.length, (i) {
      return UserModel(
        fullName: maps[i]['fullName'],
        city: maps[i]['city'],
        email: maps[i]['email'],
        phone: maps[i]['phone'],
        profileImage: maps[i]['profileImage'],
      );
    });
  }

  Future<void> clearDatabase() async {
  final db = await database;
  await db.delete('users');
  print("Database Cleared");
}

}

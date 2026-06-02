import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'task.dart';

class TaskDatabase {
  TaskDatabase._();

  static final TaskDatabase instance = TaskDatabase._();

  static const _databaseName = 'tasks.db';
  static const _databaseVersion = 1;
  static const tableName = 'tasks';

  Database? _database;

  Future<Database> get database async {
    final existingDatabase = _database;
    if (existingDatabase != null) {
      return existingDatabase;
    }

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            is_completed INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );

    return _database!;
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final rows = await db.query(tableName, orderBy: 'id DESC');
    return rows.map(Task.fromMap).toList();
  }

  Future<Task?> getTaskById(int id) async {
    final db = await database;
    final rows = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return Task.fromMap(rows.first);
  }

  Future<Task> createTask(Task task) async {
    final db = await database;
    final id = await db.insert(tableName, task.toMap());
    return task.copyWith(id: id);
  }

  Future<void> updateTask(Task task) async {
    if (task.id == null) {
      return;
    }

    final db = await database;
    await db.update(
      tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}

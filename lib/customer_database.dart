import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'customer.dart';

class CustomerDatabase {
  CustomerDatabase._();

  static final CustomerDatabase instance = CustomerDatabase._();

  static const _databaseName = 'customers.db';
  static const _databaseVersion = 1;
  static const tableName = 'customers';

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
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            phone TEXT NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  Future<List<Customer>> getAllCustomers() async {
    final db = await database;
    final rows = await db.query(tableName, orderBy: 'name COLLATE NOCASE ASC');
    return rows.map(Customer.fromMap).toList();
  }

  Future<Customer> createCustomer(Customer customer) async {
    final db = await database;
    final id = await db.insert(tableName, customer.toMap());
    return customer.copyWith(id: id);
  }

  Future<void> updateCustomer(Customer customer) async {
    final db = await database;
    await db.update(
      tableName,
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<void> deleteCustomer(int id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}

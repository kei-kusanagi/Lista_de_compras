import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> initializeDatabase() async {
  final databasesPath = await getDatabasesPath();
  final path = join(databasesPath, 'shopping_list.db');

  return await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
// Crea las tablas necesarias en la base de datos
      await db.execute('''
        CREATE TABLE IF NOT EXISTS lists (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          storeName TEXT,
          createdAt TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          listId INTEGER,
          checked INTEGER,
          productName TEXT,
          unitPrice REAL,
          units INTEGER,
          cost REAL,
          FOREIGN KEY (listId) REFERENCES lists (id)
        )
      ''');
    },
  );
}

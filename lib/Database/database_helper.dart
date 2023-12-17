import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'registration_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE registrations(id INTEGER PRIMARY KEY, name TEXT, email TEXT, dob TEXT, password TEXT)',
        );

        await db.execute(
          'CREATE TABLE IF NOT EXISTS customers(id INTEGER PRIMARY KEY, name TEXT, email TEXT, gender TEXT, habits TEXT)',
        );
      },
      version: 1,
    );

    await database.isOpen;

    return database;
  }

  Future<List<Map<String, dynamic>>> getCustomers() async {
    final database = await this.database;
    return await database.query('customers');
  }
}
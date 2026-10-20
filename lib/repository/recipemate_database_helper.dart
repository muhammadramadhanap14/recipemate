import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RecipemateDatabaseHelper {
  static final RecipemateDatabaseHelper instance = RecipemateDatabaseHelper._init();
  static Database? _database;

  RecipemateDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recipemate_tracking.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('DROP TABLE IF EXISTS tracking_details');
          await db.execute('DROP TABLE IF EXISTS user_tracking_entity');
          await _createDB(db, newVersion);
        }
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_tracking_entity (
        idTrc INTEGER PRIMARY KEY AUTOINCREMENT,
        user_create TEXT,
        create_date TEXT,
        start_date TEXT,
        finish_date TEXT DEFAULT '',
        position_start_lat REAL DEFAULT 0.0,
        position_start_lng REAL DEFAULT 0.0,
        position_finish_lat REAL DEFAULT 0.0,
        position_finish_lng REAL DEFAULT 0.0,
        tracking_status INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE tracking_details (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idTrc INTEGER,
        positionLat REAL,
        positionLng REAL,
        trackingDate TEXT,
        FOREIGN KEY (idTrc) REFERENCES user_tracking_entity (idTrc) ON DELETE CASCADE
      )
    ''');
  }
}

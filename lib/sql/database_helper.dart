import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/gym_model.dart';

class DatabaseHelper {
  static String _databaseName = "users.db";
  static final _databaseVersion = 4;
  static final table = 'users_table';
  static final columnId = 'id';
  static final columnName = 'username';
  static final columnemail = 'email';
  static final columnpassword = 'password';
  static final columningurl = 'ingurl';
  static final columnisLogedIn = 'isLoggedIn';
  static final columnage = 'age';
  static final columngymName = 'gymName';
  static final columnGymId = 'id';
  static final ColumnGymTable = 'gym';
  static final collumngymName = 'gymName';
  static final columngymBio = 'bio';
  static final columnmobileNumber = 'mobileNumber';
  static final columngymImgurl = 'imgurl';

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();

  factory DatabaseHelper() {
    return instance;
  }
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnisLogedIn INTEGER,
            $columnage TEXT NOT NULL,
            $columnemail TEXT NOT NULL,
            $columnpassword TEXT NOT NULL,
            $columningurl TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE $ColumnGymTable (
            $columnGymId INTEGER PRIMARY,
            $columngymName TEXT,
            $columngymBio TEXT,
            $columnmobileNumber TEXT,
            $columngymImgurl TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE users_gyms (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER REFERENCES $table($columnId),
            gym_id INTEGER REFERENCES $ColumnGymTable($columnGymId)
          )
          ''');
  }

  Future<void> printAllData(String tableName) async {
    Database? db = await instance.database;
    final results = await db.query(tableName);

    for (var row in results) {
      print(row);
    }
  }

  Future<List<Map<String, dynamic>>> getDataFromDatabase() async {
    Database? db = await instance.database;
    return await db.query(ColumnGymTable);
  }

  Future<List<GymModel>> getDevices() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('gym');
    return List.generate(maps.length, (i) {
      return GymModel(
          bio: maps[i][columngymBio],
          gymName: maps[i][columngymName],
          id: 0,
          imgUrl: maps[i][columningurl],
          mobileNumber: maps[i][columnmobileNumber]);
    });
  }

  Future<void> deleteRaw(String databaseName, int rowId) async {
    final db = await database;
    db.rawDelete('DELETE FROM $databaseName WHERE id = ?', [rowId]);
  }

  Future<void> deleteGymsDB() async {
    final db = await database;
    db.delete('gym');
  }
}

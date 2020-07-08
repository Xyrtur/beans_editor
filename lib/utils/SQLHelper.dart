import 'index.dart';

// ignore: camel_case_types
class SQLHelper {
  final databaseName = "beans.db";
  static SQLHelper _sqlHelper;
  static Database _database;

  SQLHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory SQLHelper() {
    if (_sqlHelper == null) {
      _sqlHelper = SQLHelper._createInstance(); // This is executed only once, singleton object
    }
    return _sqlHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/' + databaseName;

    // Open/create the database at a given path
    var budgetsDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return budgetsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE IF NOT EXISTS beans('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'title BLOB,'
        'content TEXT,'
        'date_created INTEGER,'
        'date_last_edited INTEGER)');
  }

  Future<int> insertBean(Beans bean, bool isNew) async {
    Database db = await this.database;
    await db.insert("beans", isNew ? bean.toMap(false) : bean.toMap(true),
        conflictAlgorithm: ConflictAlgorithm.replace);

    if (isNew) {
      var latestId;
      //get latest note id, the new one that was just inserted
      await db
          .rawQuery('SELECT id FROM beans ORDER BY date_last_edited DESC LIMIT 1')
          .then((List<Map<String, dynamic>> resultList) {
        resultList[0].forEach((key, val) => latestId = val);
      });
      return latestId;
    }

    return bean.id;
  }

  Future<bool> deleteBean(Beans bean) async {
    if (bean.id != -1) {
      Database db = await this.database;
      try {
        await db.delete("beans", where: "id = ?", whereArgs: [bean.id]);
        return true;
      } catch (Error) {
        print('Error deleting ${bean.id}: ${Error.toString()}');
        return false;
      }
    }
  }

  Future<List<Map<String, dynamic>>> selectAllBeans() async {
    Database db = await this.database;
    var data;
    await db
        .rawQuery('SELECT * FROM beans ORDER BY date_last_edited DESC')
        .then((List<Map<String, dynamic>> resultList) {
      data = resultList;
    });

    return data;
  }
}

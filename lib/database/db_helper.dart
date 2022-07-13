import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'collection.dart';
import 'task.dart';

class DatabaseHelper {
  static const _dbName = 'Do_It';
  static const _dbVersion = 1;

  static const collectionTable = "collection";
  static const collectionId = 'id';
  static const collectionName = 'name';
  static const collectionDate = 'date';
  static const collectionColor = 'color';

  static const taskTable = "task";
  static const taskId = 'id';
  static const taskName = 'name';
  static const taskDate = 'date';
  static const taskIsCompleted = 'completed';
  static const taskCollectionId = 'collectionId';

  static final DatabaseHelper instance = DatabaseHelper._internal();

  factory DatabaseHelper() => instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async => _database ?? await _initiateDatabase();

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) {
        db.execute('''
  CREATE TABLE $collectionTable(
  $collectionId  INTEGER PRIMARY KEY AUTOINCREMENT,
  $collectionName TEXT,
  $collectionDate INTEGER,
  $collectionColor INTEGER NOT NULL)
  ''');

        db.execute(''' 
CREATE TABLE $taskTable(
    $taskId INTEGER PRIMARY KEY AUTOINCREMENT,
    $taskName TEXT NOT NULL,
    $taskDate INTEGER NOT NULL,
    $taskIsCompleted INTEGER NOT NULL,
    $taskCollectionId INTEGER,
    FOREIGN KEY ($taskCollectionId)
    REFERENCES $collectionTable ($collectionId) 
)
''');
      },
    );
  }


  Future<int> collectionInsert(Collection collection) async {
    Database db = await instance.database;
    int collectingID = await db.insert(
      collectionTable,
      collection.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return collectingID;
  }

  Future<List<Collection>> getCollectionList() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(collectionTable);

    return List.generate(maps.length, (index) {
      return Collection(
        id: maps[index][collectionId],
        name: maps[index][collectionName],
        date: maps[index][collectionDate],
        color: maps[index][collectionColor],
      );
    });
  }

  Future collectionUpdate(int id, String name) async {
    Database db = await instance.database;
    await db.rawUpdate(
        'UPDATE $collectionTable SET $collectionName= ? WHERE $collectionId = ?',
        [name, id]);
  }

  Future collectionColorUpdate(int id, int color) async {
    Database db = await instance.database;
    await db.rawUpdate(
        'UPDATE $collectionTable SET $collectionColor= ? WHERE $collectionId = ?',
        [color, id]);
  }

  Future<void> collectionDelete(int cId) async {
    Database db = await instance.database;
    await db.delete(
      collectionTable,
      where: '$collectionId = ?',
      whereArgs: [cId],
    );
  }

  Future<void> taskInsert(Task task) async {
    Database db = await instance.database;
    await db.insert(
      taskTable,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> taskQuery(int? id) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db
        .query(taskTable, where: '$taskCollectionId = ?', whereArgs: [id]);

    return List.generate(maps.length, (index) {
      return Task(
        id: maps[index][taskId],
        name: maps[index][taskName],
        date: maps[index][taskDate],
        isCompleted: maps[index][taskIsCompleted],
        collectionId: maps[index][taskCollectionId],
      );
    });
  }

  Future taskUpdate(Task task, int isCompleted) async {
    Database db = await instance.database;
    // await db.update(collectionTable, task.toMap(),
    //  where: '$taskColumnId = ?', whereArgs: [task.id]
    await db.rawUpdate(
        'UPDATE $taskTable SET $taskIsCompleted = ? WHERE $taskId = ?',
        [isCompleted, task.id]);
  }

  Future taskEdit(Task task, String name) async {
    Database db = await instance.database;
    // await db.update(collectionTable, task.toMap(),
    //  where: '$taskColumnId = ?', whereArgs: [task.id]
    await db.rawUpdate('UPDATE $taskTable SET $taskName = ? WHERE $taskId = ?',
        [name, task.id]);
  }


  Future<void> taskDelete(int tId) async {
    Database db = await instance.database;
    await db.delete(
      taskTable,
      where: '$taskId = ?',
      whereArgs: [tId],
    );
  }

  Future<int?> countTask(int collectionId) async {
    Database db = await instance.database;
    var x = await db.rawQuery(
        'SELECT COUNT (*) from $taskTable WHERE $taskCollectionId=?',
        [collectionId]);
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  Future<int?> countCompletedTask(int collectionId) async {
    Database db = await instance.database;
    var x = await db.rawQuery(
        'SELECT COUNT (*) from $taskTable WHERE $taskIsCompleted =? AND $taskCollectionId=?',
        [1, collectionId]);
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  Future<void> taskCollectionDelete(int collectionId) async {
    Database db = await instance.database;
    await db.delete(
      taskTable,
      where: '$taskCollectionId = ?',
      whereArgs: [collectionId],
    );
  }

  Future<int?> listColor(int collectionId) async {
    Database db = await instance.database;
    var x = await db.rawQuery(
        'SELECT $collectionColor from $collectionTable WHERE $collectionId=?',
        [collectionId]);
    int? color = Sqflite.firstIntValue(x);
    return color;
  }
}

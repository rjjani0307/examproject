import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
  static Database? _db;
  static final int _veraion = 1;
  static final String _tableName = "tasks";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + "tasks.db";
      _db =
      await openDatabase(_path, version: _veraion, onCreate: (db, version) {
        print("Createting a new one");
        return db.execute(
          "CREATE TABLE $_tableName("
              "id INTEGER PRIMARY KEY, "
              "title STRING,"
              "note TEXT,"
              "date STRING,"
              "startTime STRING,"
              "endTime STRING,"
              "remind INTEGER,"
              "repeat STRING,"
              "color INTEGER,"
              "isCompleted INTEGER)",
        );
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    print("Insert function called");
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<int?> updateTask(Task? task) async {
    return await _db?.update(_tableName, task!.toJson(),
        where: "id = ?", whereArgs: [task.id]);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("Query function called");
    return await _db!.query(_tableName);
  }

  static Future deleteTask(Task task)async{
    print('deleting');
    await _db?.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static Future<Task> getTask(int id)async{
    final data = await _db?.query(
      _tableName,
      where: 'id=?',
      whereArgs: [id],
    );
    print(data);
    return Task.fromJson(data!.first);
  }


  static update(int id) async{
    return await _db!.rawUpdate('''    
      UPDATE tasks
      SET isCompleted = ?
      WHERE id=? 
       ''', [1, id]);
  }
}

import 'package:advanced_todo_app/modules/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? db;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  static Future open() async {
    if (db != null) {
      debugPrint('db isn\'t null');
      return;
    }
    try {
      var databasesPath = await getDatabasesPath();
      String path = '$databasesPath task1.db';
      db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        debugPrint('creating new database');
        await db.execute('CREATE TABLE $_tableName ('
            'id INTEGER primary key autoincrement,'
            'title STRING ,note text ,date STRING,'
            'startTime STRING ,endTime STRING ,'
            'remaind INTEGER ,repeat STRING,'
            'color INTEGER ,'
            'isCompleted INTEGER)');
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    print('inserting###########');

    try {
      return await db!.insert(_tableName, task!.toJson());
    }
    catch (e) {
      print('here we are #############');
      print(e);
      return 9000;
    }
  }

  static Future<int> delete(Task? task) async {
    print('deleting###########');
    return await db!.delete(_tableName, whereArgs: [task!.id], where: 'id =?');
  }static Future<int> deleteAll() async {
    print('deletingAll###########');
    return await db!.delete(_tableName,);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print('query###########');
    return await db!.query(_tableName);
  }

  static Future<int> update(int id) async {
    print('updating###########');
    return await db!.rawUpdate('''
    UPDATE tasks 
    SET isCompleted=?
    WHERE id=?
    ''', [1, id]);
  }
}

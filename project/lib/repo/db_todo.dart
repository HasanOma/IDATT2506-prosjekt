import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

const String DB_NAME = 'db_todolist';

class DB {
  setDatabase() async {
    var dir = await getApplicationDocumentsDirectory();
    var path = join(dir.path, DB_NAME);
    var database =
    await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);
    return database;
  }

  _onCreatingDatabase(Database database, int version) async {
    await database.execute(
        '''CREATE TABLE categories(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        name TEXT, description TEXT)''');

    // Create table todos
    await database.execute(
        '''CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        title TEXT, description TEXT, category TEXT, prevCat TEXT, 
        todoDate TEXT, isFinished BOOLEAN)''');

    await database.execute(
      '''INSERT INTO categories (id,name,description) VALUES (0,"Completed",
      "Completed tasks")'''
    );

    await database.execute(
        '''INSERT INTO categories (id,name,description) VALUES (1,"no cat",
        "no category")'''
    );
  }

}

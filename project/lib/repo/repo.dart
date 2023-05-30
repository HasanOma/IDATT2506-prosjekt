import 'package:project/models/category.dart';
import 'package:sqflite/sqflite.dart';

import 'db_todo.dart';

class Repo {
  DB databaseConnection = DB();

  Repo();

  static Database? _database;

  // Check if database is exist or not
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await databaseConnection.setDatabase();
    return _database;
  }

  // Inserting data to Table
  insertData(table, data) async {
    var con = await database;
    return await con?.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Read data from Table
  readData(table) async {
    var con = await database;
    return await con?.query(table);
    }

  // Read data from table by Id
  readDataById(table, itemId) async {
    var con = await _database;
    return await con?.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  // Update data from table
  updateData(table, data) async {
    var con = await _database;
    return await con
        ?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  // Delete data from table
  deleteData(table, data) async {
    var con = await _database;
    return await con?.delete(table, where: 'id=?', whereArgs: [data['id']]);
  }

  deleteDataById(table, itemId) async {
    var con = await database;
    return await con?.rawDelete("DELETE FROM $table WHERE id = $itemId");
  }

  // Read data from table by Column Name
  readDataByColumnName(table, columnName, columnValue) async {
    var con = await _database;
    return await con
        ?.query(table, where: '$columnName=?', whereArgs: [columnValue]);
  }

  completeTodo(table, data) async {
    var con = await _database;
    return await con
        ?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }
}

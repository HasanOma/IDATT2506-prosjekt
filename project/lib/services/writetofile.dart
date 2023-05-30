import 'dart:developer';

import 'package:project/services/todo_service.dart';

import '../models/todo.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class WriteToFile {
  static WriteToFile? _instance;

  WriteToFile._internal(){
    _instance = this;
  }

  factory WriteToFile() => _instance ?? WriteToFile._internal();

  TodoService _todoService = TodoService();

  String tableName = "";

  List<Todo> _list = <Todo>[];

  Future<String> get _localPath async {
    final dir = await getApplicationDocumentsDirectory();
    print("Path to file: $dir/$tableName.json");
    return dir.path;
  }

  Future<File> get _localFile async {
    // AsyncSnapshot.waiting();
    final path = await _localPath;
    return File('$path/$tableName.json');
  }

  //get from db and add to _todoList
  getFromDB(category) async {
    var todos = await _todoService.readTodosByCategory(category);
    var i = 0;
    todos.forEach((todo) {
      var model = Todo(id: todo['id'], title: todo['title'],
          description: todo['description'], todoDate: todo['todoDate'],
          category: todo['category'], prevCat: todo['prevCat']);
      if(!_list.contains(model)){
        _list.add(model);
      }
      if(_list[i].category != category){
        _list.removeAt(i);
        i++;
      }
    });
  }

  Future<File> write(tableName) async {
    this.tableName = tableName;
    print(tableName);
    File file = await _localFile;
    getFromDB(tableName);
    String jsonString = jsonEncode(_list);
    // Write the file
    log(jsonString);
    return file.writeAsString(jsonString);
  }
}

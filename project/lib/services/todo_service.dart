import 'package:flutter/foundation.dart';
import 'package:project/models/todo.dart';
import 'package:project/repo/repo.dart';

class TodoService {
  Repo _repository = Repo();

  TodoService();
  // create todos
  saveTodo(Todo todo) async {
    return await _repository.insertData('todos', todo.todoMap());
  }

  // read todos
  readTodos() async {
    return await _repository.readData('todos');
  }

  completeTodo(Todo data) async {
    return await _repository.completeTodo('todos', data.todoMap());
  }

  deleteTodo(todo) async {
    return await _repository.deleteDataById("todos", todo);
  }

  // read todos by category
  readTodosByCategory(category) async {
    return await _repository.readDataByColumnName(
        'todos', 'category', category);
  }
}
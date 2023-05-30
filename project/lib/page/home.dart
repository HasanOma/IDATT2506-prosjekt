import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/nav/navigation.dart';
import 'package:project/models/todo.dart';
import 'package:project/page/todo_page.dart';
import 'package:project/services/todo_service.dart';
import 'package:provider/provider.dart';

import '../controller/file_controller.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TodoService _todoService;

  List<Todo> _todoList = <Todo>[];

  var allTodos = 0;

  @override
  initState() {
    super.initState();
    getAllTodos();
  }

  getAllTodos() async {
    _todoService = TodoService();
    _todoList = <Todo>[];

    var todos = await _todoService.readTodos();
    var i = 0;
    todos.forEach((todo) {
      setState(() {
        allTodos++;
        var model = Todo(id: todo['id'], title: todo['title'],
            description: todo['description'], todoDate: todo['todoDate'],
            category: todo['category'], prevCat: todo['prevCat']);
        if(!_todoList.contains(model) || model.category != "Completed"){
          _todoList.add(model);
        }
      });
    });
    _todoList.removeWhere((element) => element.category == "Completed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todolist project'),
      ),
      drawer: Navigaton(),
      body: ListView.builder(
          itemCount: _todoList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top:8.0, left: 8.0, right: 8.0),
              child: Card(
                  clipBehavior: Clip.antiAlias,
                  color: (_todoList[index].category == 'Completed') ? Colors.green : null,
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Colors.blueGrey,
                        style: BorderStyle.solid
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: ListTile(
                    tileColor: null,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_todoList[index].title ?? 'No Title'),
                        Text(_todoList[index].todoDate ?? 'No Date'),
                      ],
                    ),
                    subtitle:Text(_todoList[index].category ?? 'No Category'),
                    // trailing:
                    onTap: () => completeTask(index),
                  ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TodoPage())),
        child: const Icon(Icons.add),
      ),
    );
  }

  completeTask(index) async {
    setState(() {
      if(_todoList[index].category != "Completed"){
        _todoList[index].isFinished = true;
        _todoList[index].prevCat = _todoList[index].category;
        _todoList[index].category = "Completed";
        _todoService.completeTodo(_todoList[index]);
        context.read<FileController>().writeText(tableName: "Completed");
        _todoList.remove(_todoList[index]);
      } else if(_todoList[index].category == "Completed"){
        _todoList[index].isFinished = false;
        _todoList[index].category = _todoList[index].prevCat!;
        context.read<FileController>().writeText(tableName: _todoList[index].prevCat!);
        _todoService.completeTodo(_todoList[index]);
      }
    });
  }
}

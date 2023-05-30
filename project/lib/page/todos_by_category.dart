import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project/nav/navigation.dart';
import 'package:project/models/todo.dart';
import 'package:project/controller/file_controller.dart';
import 'package:project/page/todo_page.dart';
import 'package:project/services/todo_service.dart';
import 'package:project/services/writetofile.dart';
import 'package:provider/provider.dart';

class TodosByCategory extends StatefulWidget {
  final String category;

  TodosByCategory({required this.category});

  @override
  _TodosByCategoryState createState() => _TodosByCategoryState();
}
//TODO write to file
class _TodosByCategoryState extends State<TodosByCategory> {
  List<Todo> _todoList = <Todo>[];
  TodoService _todoService = TodoService();
  String lastClicked = "";
  late WriteToFile writeToFile;

  String cat = "";

  @override
  void initState() {
    super.initState();
    getTodosByCategories();
  }

  getTodosByCategories() async {
    cat = widget.category;
    var todos = await _todoService.readTodosByCategory(widget.category);
    todos.forEach((todo) {
      setState(() {
        if (widget.category == 'Completed') {
          print(widget.category);
        }
        var model = Todo(id: todo['id'], title: todo['title'],
            description: todo['description'], todoDate: todo['todoDate'],
            category: widget.category, prevCat: todo['prevCat']);
        if(!_todoList.contains(model)){
          _todoList.add(model);

        }
      });
    });
  }

  completeTodo(index) async {
    setState(() {
      if(_todoList[index].category != "Completed"){
        _todoList[index].isFinished = true;
        _todoList[index].prevCat = _todoList[index].category;
        _todoList[index].category = "Completed";
        _todoService.completeTodo(_todoList[index]);
        context.read<FileController>().writeText(tableName: "Completed");
        _todoList.remove(_todoList[index]);
        context.read<FileController>().writeText(tableName: "Completed");
      } else if(_todoList[index].category == "Completed"){
        _todoList[index].isFinished = false;
        _todoList[index].category = _todoList[index].prevCat!;
        _todoService.completeTodo(_todoList[index]);
        context.read<FileController>().writeText(tableName: _todoList[index].prevCat!);
        _todoList.remove(_todoList[index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
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
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_todoList[index].title ?? 'No Title'),
                        Text(_todoList[index].todoDate ?? 'No Date'),

                      ],
                    ),
                    subtitle: Text(_todoList[index].category ?? 'No Category'),
                    trailing: IconButton(
                                                icon: Icon(
                                                  (cat =="no cat") ? Icons.delete: null,
                                                  color: (cat =="no cat") ? Colors.red: null,
                                                ),
                                                onPressed: () {
                                                  if(cat == "no cat"){
                                                    int? tId = _todoList[index].id;
                                                    _deleteFormDialog(context, tId,
                                                        _todoList[index].title);
                                                  }
                                                }
                                            ),
                    onTap: () => completeTodo(index),
                  )
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


  _deleteFormDialog(BuildContext context, categoryId, name) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                // color: Colors.green,
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                // color: Colors.red,
                onPressed: () async {
                  var result =
                  await _todoService.deleteTodo(categoryId);
                  // deleteTodos(name);
                  if (result > 0) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => TodosByCategory(category: cat)));
                    // getAllCategories();
                    _showSuccessSnackBar(Text('Todo $name deleted'));
                  }
                },
                child: const Text('Delete'),
              ),
            ],
            title: const Text('Are you sure you want to delete this?\n All '
                'This todo will be deleted!'),
          );
        });
  }

  _showSuccessSnackBar(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: message));
  }

  isCompleted(index) {
    return (cat =='no cat');
  }
}
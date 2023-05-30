import 'package:flutter/material.dart';
import 'package:project/models/todo.dart';
import 'package:project/page/home.dart';
import 'package:project/services/category_service.dart';
import 'package:project/controller/file_controller.dart';
import 'package:project/services/todo_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../services/writetofile.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  var _titleController = TextEditingController();

  var _descriptionController = TextEditingController();

  var _dateController = TextEditingController();

  List<Todo> _todoList = <Todo>[];

  var _selectedValue;

  var _categories = <DropdownMenuItem>[];

  late WriteToFile writeToFile;

  var allTodos = 0;

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  size(category) async {
    var todoService = TodoService();
    _todoList = <Todo>[];
    var todos = await todoService.readTodos();

    todos.forEach((todo) {
      setState(() {
        allTodos++;
        if (category == 'completed') {
          print(category);
        }
        var model = Todo(id: todo['id'], title: todo['title'],
            description: todo['description'], todoDate: todo['todoDate'],
            category: category, prevCat: todo['prevCat']);
        if(!_todoList.contains(model)){
          _todoList.add(model);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      if(category['name'] != "Completed"){
        setState(() {
          _categories.add(DropdownMenuItem(
            value: category['name'],
            child: Text(category['name']),
          ));
        });
      }
    });
  }

  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }


  _showSuccessSnackBar(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: message));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: const Text('Create Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                  labelText: 'Title', hintText: 'Write Todo Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                  labelText: 'Description', hintText: 'Write Todo Description'),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'yyyy-mm-dd',
                prefixIcon: InkWell(
                  onTap: () {
                    _selectedTodoDate(context);
                  },
                  child: const Icon(Icons.calendar_today),
                ),
              ),
            ),
            DropdownButtonFormField(
              value: _selectedValue,
              items: _categories,
              hint: const Text('Category'),
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                  size(_selectedValue.toString());
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                var todoObject = Todo(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  category: _selectedValue.toString(),
                  prevCat: "",
                  todoDate: _dateController.text,
                );
                if (_selectedValue == null || _selectedValue.toString() == "null"){
                  todoObject.category = "no cat";
                }
                var todoService = TodoService();
                var result = await todoService.saveTodo(todoObject);
                context.read<FileController>().writeText(tableName: _selectedValue.toString());
                if (result > 0) {
                  _showSuccessSnackBar(const Text('Todo created'));
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Home()));
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: const EdgeInsets.symmetric(),
              ),
              child: const Text(
                'Create',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

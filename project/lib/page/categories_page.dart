import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/models/category.dart';
import 'package:project/page/home.dart';
import 'package:project/services/category_service.dart';
import 'package:project/services/todo_service.dart';

import '../models/todo.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  var _categoryService = CategoryService();

  List<Category> _categoryList = <Category>[];

  var _todoService = TodoService();
  var _todoList = <Todo>[];

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllCategories() async {
    _categoryList = <Category>[];
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category(id: category['id'], name: category['name'],
            description: category['description']);
        if(!_categoryList.contains(category)) {
          _categoryList.add(categoryModel);
        }
      });
    });
    var todos = await _todoService.readTodos();
    todos.forEach((todo) {
      setState(() {
        var model = Todo(id: todo['id'], title: todo['title'],
            description: todo['description'], todoDate: todo['todoDate'],
            category: todo['category'], prevCat: todo['prevCat']);
        if(!_todoList.contains(model)){
          print(model.toString());
          _todoList.add(model);
          // _todoService.deleteTodo(todo);
        }
      });
    });
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
                  await _categoryService.deleteCategory(categoryId);
                  deleteTodos(name);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllCategories();
                    _showSuccessSnackBar(const Text('Category deleted'));
                  }
                },
                child: const Text('Delete'),
              ),
            ],
            title: const Text('Are you sure you want to delete this?\n All '
                'todos in this category will be deleted!'),
          );
        });
  }

  _showSuccessSnackBar(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: message));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Home())),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text('Categories'),
      ),
      body: ListView.builder(
          itemCount: _categoryList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Card(
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
                      Text(
                        _categoryList[index].name,
                        textAlign: TextAlign.center,
                      ),
                      IconButton(
                          icon: Icon(
                            isCompleted(index) ? null: Icons.delete,
                            color: isCompleted(index) ? null: Colors.red,
                          ),
                          onPressed: () {
                            if(_categoryList[index].name!='Completed'){
                              _deleteFormDialog(context, _categoryList[index].id,
                                  _categoryList[index].name);
                            }
                          })
                    ],
                  ),
                ),
              ),
            );
          }),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _showFormDialog(context);
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  void deleteTodos(category) async {
    var todos = await TodoService().readTodosByCategory(category);
    todos.forEach((todo) {
      print(todo["id"]);
      setState(() {
        TodoService().deleteTodo(todo["id"]);
      });
    });
  }

  isCompleted(index) {
    return (_categoryList[index].name =='Completed' || _categoryList[index].name =='no cat');
  }
}
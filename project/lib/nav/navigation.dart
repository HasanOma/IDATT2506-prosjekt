import 'package:flutter/material.dart';
import 'package:project/page/categories_page.dart';
import 'package:project/page/home.dart';
import 'package:project/page/todos_by_category.dart';
import 'package:project/services/category_service.dart';

class Navigaton extends StatefulWidget {
  @override
  _NavigatonState createState() => _NavigatonState();
}
class _NavigatonState extends State<Navigaton> {
  List<Widget> _categoryList = <Widget>[];

  var _categoryTitleController = TextEditingController();

  CategoryService _categoryService = CategoryService();

  FocusNode focusNode = FocusNode();

  @override
  initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var categories = await _categoryService.readCategories();

    categories.forEach((category) {
      if(!_categoryList.contains(category)){
        setState(() {
          _categoryList.add(InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TodosByCategory(category: category['name'],))),
            child: ListTile(
              title: Text(category['name']),
            ),
          ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            // const UserAccountsDrawerHeader(
            //   accountName: Text('Ola Normann'),
            //   accountEmail: Text('ola@normann.no'),
            //   decoration: BoxDecoration(color: Colors.blueGrey),
            // ),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Colors.lightBlue,
              ),
              title: const Text('All Todos'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Home())),
            ),
            ListTile(
              leading: const Icon(
                Icons.view_list,
                color: Colors.blueGrey,

              ),
              title: const Text('Categories'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Categories())),
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(8),
              title: TextField(
                  controller: _categoryTitleController,
                  decoration: InputDecoration(
                      icon: const Icon(Icons.add_box_outlined),
                      labelText: 'Add a category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          style: BorderStyle.solid,
                        ),
                      ),
                      filled: true,
                      hintStyle: const TextStyle(
                        color: Colors.blueGrey,
                      ),
                      fillColor: Colors.white70),
                  focusNode: focusNode,
                  onSubmitted: (value){
                    if(value.trim().isNotEmpty){
                      setState(() {
                        _categoryService.saveCategoryNavBar(
                            _categoryList.length+1, _categoryTitleController.text);
                        _categoryList.add(
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TodosByCategory(
                                      category: _categoryTitleController.text),
                                )),
                            child: ListTile(
                                title: Text(_categoryTitleController.text)),
                          ),
                        );
                      });
                      print(value);
                      AsyncSnapshot.waiting();
                    }
                    _categoryTitleController.clear();
                    focusNode.requestFocus();
                  }
              ),
            ),
            Column(
              children: _categoryList,
            ),
          ],
        ),
      ),
    );
  }
}

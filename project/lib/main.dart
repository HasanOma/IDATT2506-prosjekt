import 'package:flutter/material.dart';
import 'package:project/page/home.dart';
import 'package:project/controller/file_controller.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => FileController())],
    child: App(),
  ),
);

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.blueGrey[800]),
      ),
      home: Home(),
    );
  }
}
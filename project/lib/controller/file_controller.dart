// import 'dart:html';
import 'dart:typed_data';

import 'package:project/services/writetofile.dart';
import 'package:project/models/todo.dart';
import 'package:flutter/material.dart';

class FileController extends ChangeNotifier {
  late Todo _todo;
  late Uint8List _imageByteList;

  Todo get user => _todo;
  Uint8List get imageByteList => _imageByteList;

  writeText({required String tableName}) async {
    await WriteToFile().write(tableName);
    notifyListeners();
  }
}
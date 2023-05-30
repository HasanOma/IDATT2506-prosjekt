import 'package:flutter/foundation.dart';

class Category {
  int? id;
  String name;
  String description;

  Category({this.id, required this.name, required this.description});

  categoryMap() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['description'] = description;

    return mapping;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;
}

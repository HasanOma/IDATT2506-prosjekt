class Todo {
  int? id;
  String title;
  String description;
  String category;
  String? prevCat;
  String todoDate;
  bool? isFinished;

  Todo({this.id, required this.title, required this.description,
    required this.category, this.prevCat, required this.todoDate});

  todoMap() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['title'] = title;
    mapping['description'] = description;
    mapping['category'] = category;
    mapping['prevCat'] = prevCat;
    mapping['todoDate'] = todoDate;
    mapping['isFinished'] = isFinished;

    return mapping;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'prevCat': prevCat,
    'todoDate': todoDate,
    'isFinished': isFinished,
  };

  @override
  String toString() {
    return 'Todo{id: $id, title: $title, description: $description, '
        'category: $category, todoDate: $todoDate, isFinished: $isFinished}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Todo &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          category == other.category &&
          todoDate == other.todoDate &&
          isFinished == other.isFinished;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      category.hashCode ^
      todoDate.hashCode ^
      isFinished.hashCode;
}

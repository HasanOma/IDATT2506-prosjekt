import 'package:project/models/category.dart';
import 'package:project/repo/repo.dart';

class CategoryService {
  Repo repository= Repo();

  CategoryService();
  // Create data
  saveCategory(Category category) async {
    return await repository.insertData('categories', category.categoryMap());
  }

  saveCategoryNavBar(id, name) async {
    Category category = Category(id: id, name: name, description: '');
    return await repository.insertData("categories", category.categoryMap());
  }

  // Read data from table
  readCategories() async {
    return await repository.readData('categories');
  }

  // Read data from table by Id
  readCategoryById(categoryId) async {
    return await repository.readDataById('categories', categoryId);
  }

  // Update data from table
  updateCategory(Category category) async {
    return await repository.updateData('categories', category.categoryMap());
  }

  // Delete data from table
  deleteCategory(category) async{
    return await repository.deleteDataById('categories', category);
  }
}

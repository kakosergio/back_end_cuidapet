import '../../../../entities/category.dart';

abstract interface class CategoriesService {
  Future<List<Category>> findAll();

}
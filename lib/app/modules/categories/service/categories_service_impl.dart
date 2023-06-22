import 'package:injectable/injectable.dart';

import 'package:back_end_cuidapet/app/modules/categories/data/categories_repository.dart';
import 'package:back_end_cuidapet/entities/category.dart';

import './categories_service.dart';

@LazySingleton(as: CategoriesService)
class CategoriesServiceImpl implements CategoriesService {
  final CategoriesRepository _categoriesRepository;

  CategoriesServiceImpl({
    required CategoriesRepository categoriesRepository,
  }) : _categoriesRepository = categoriesRepository;

  @override
  Future<List<Category>> findAll() => _categoriesRepository.findAll();
}

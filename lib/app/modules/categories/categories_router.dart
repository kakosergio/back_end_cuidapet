import 'package:back_end_cuidapet/app/modules/categories/controller/categories_controller.dart';
import 'package:back_end_cuidapet/app/routers/routers.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/shelf_router.dart';

class CategoriesRouter implements Routers {
  @override
  void configure(Router router) {
    final categoriesController = GetIt.I.get<CategoriesController>();

    router.mount('/categories/', categoriesController.router);
  }
}

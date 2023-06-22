import 'dart:async';
import 'dart:convert';

import 'package:back_end_cuidapet/app/logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:back_end_cuidapet/app/modules/categories/service/categories_service.dart';

part 'categories_controller.g.dart';

@Injectable()
class CategoriesController {
  final CategoriesService _categoriesService;
  final Logger _log;

  CategoriesController({
    required CategoriesService categoriesService,
    required Logger log,
  })  : _categoriesService = categoriesService,
        _log = log;

  @Route.get('/')
  Future<Response> findAll(Request request) async {
    try {
      final categories = await _categoriesService.findAll();
      return Response.ok(jsonEncode(categories
          .map((e) => {
                'id': e.id,
                'name': e.name,
                'type': e.type,
              })
          .toList()));
    } catch (e, s) {
      _log.error('Erro ao buscar categorias', e, s);
      return Response.internalServerError();
    }
  }

  Router get router => _$CategoriesControllerRouter(this);
}

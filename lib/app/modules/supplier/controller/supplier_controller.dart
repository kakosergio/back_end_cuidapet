import 'dart:async';
import 'dart:convert';

import 'package:back_end_cuidapet/app/logger/logger.dart';
import 'package:back_end_cuidapet/entities/supplier.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:back_end_cuidapet/app/modules/supplier/service/supplier_service.dart';

part 'supplier_controller.g.dart';

@Injectable()
class SupplierController {
  final SupplierService _supplierService;
  final Logger _log;

  SupplierController({
    required SupplierService supplierService,
    required Logger log,
  })  : _supplierService = supplierService,
        _log = log;

  @Route.get('/')
  Future<Response> findNearByMe(Request request) async {
    try {
      final lng = double.tryParse(request.url.queryParameters['lng'] ?? '');
      final lat = double.tryParse(request.url.queryParameters['lat'] ?? '');

      if (lat == null || lng == null) {
        return Response.badRequest(
            body: jsonEncode({'message': 'Latitude e longitude obrigatorios'}));
      }

      final suppliers = await _supplierService.findNearByMe(lat, lng);
      final result = suppliers
          .map((e) => {
                'id': e.id,
                'name': e.name,
                'logo': e.logo,
                'distance': e.distance,
                'category_id': e.categoryId
              })
          .toList();
      return Response.ok(jsonEncode(result));
    } catch (e, s) {
      _log.error('Erro ao buscar fornecedores nas proximidades', e, s);
      return Response.internalServerError(
          body: jsonEncode(
              {'message': 'Erro ao buscar fornecedores nas proximidades'}));
    }
  }

  @Route.get('/<id|[0-9]+>')
  Future<Response> findById(Request request, String id) async {
    final supplier = await _supplierService.findById(int.parse(id));

    if (supplier == null) {
      return Response.ok(jsonEncode({}));
    }
    return Response.ok(_supplierMapper(supplier));
  }

  @Route.get('/<supplierId|[0-9]+>/business')
  Future<Response> findBusinessBySupplierId(
      Request request, String supplierId) async {
    try {
      final supplierBusiness =
          await _supplierService.findBusinessBySupplier(int.parse(supplierId));

      return Response.ok(jsonEncode(
        supplierBusiness
            .map((e) => {
                  'id': e.id,
                  'supplier_id': e.supplierId,
                  'name': e.name,
                  'price': e.price,
                })
            .toList(),
      ));
    } catch (e, s) {
      _log.error('Erro ao buscar serviços por id de fornecedor', e, s);
      return Response.internalServerError(
          body: jsonEncode(
              {'message': 'Erro ao buscar serviços por id de fornecedor'}));
    }
  }

  @Route.get('/user')
  Future<Response> checkUserExists(Request request) async{
     return Response.ok(jsonEncode(''));
  }

  String _supplierMapper(Supplier supplier) => jsonEncode({
        'id': supplier.id,
        'name': supplier.name,
        'logo': supplier.logo,
        'address': supplier.address,
        'phone': supplier.phone,
        'latitude': supplier.lat,
        'longitude': supplier.lng,
        'category': {
          'id': supplier.category?.id,
          'name': supplier.category?.name,
          'type': supplier.category?.type
        }
      });

  Router get router => _$SupplierControllerRouter(this);
}

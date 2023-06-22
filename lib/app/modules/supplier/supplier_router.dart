import 'package:back_end_cuidapet/app/modules/supplier/controller/supplier_controller.dart';
import 'package:back_end_cuidapet/app/routers/routers.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/shelf_router.dart';

class SupplierRouter implements Routers {
  @override
  void configure(Router router) {
    final supplierController = GetIt.I.get<SupplierController>();

    router.mount('/supplier/', supplierController.router);
  }
}

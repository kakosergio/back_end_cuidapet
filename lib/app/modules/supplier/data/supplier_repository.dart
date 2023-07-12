import 'package:back_end_cuidapet/dtos/supplier_near_by_me_dto.dart';
import 'package:back_end_cuidapet/entities/supplier_business.dart';

import '../../../../entities/supplier.dart';

abstract interface class SupplierRepository {
  Future<List<SupplierNearByMeDto>> findNearByPosition(
      double lat, double lng, int distance);

  Future<Supplier?> findById(int id);

  Future<List<SupplierBusiness>> findBusinessBySupplierId(int supplierId);

  Future<bool> checkUserEmailExists(String email);

  Future<int> saveSupplier(Supplier supplier);
}

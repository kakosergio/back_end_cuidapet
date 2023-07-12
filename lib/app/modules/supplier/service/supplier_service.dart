import 'package:back_end_cuidapet/app/modules/supplier/view_models/create_supplier_user_view_model.dart';
import 'package:back_end_cuidapet/entities/supplier_business.dart';

import '../../../../dtos/supplier_near_by_me_dto.dart';
import '../../../../entities/supplier.dart';

abstract interface class SupplierService {
  Future<List<SupplierNearByMeDto>> findNearByMe(double lat, double lng);
  Future<Supplier?> findById(int id);
  Future<List<SupplierBusiness>> findBusinessBySupplier(int supplierId);
  Future<bool> checkUserEmailExists(String email);
  Future<void> createSupplierUser(CreateSupplierUserViewModel model);
}

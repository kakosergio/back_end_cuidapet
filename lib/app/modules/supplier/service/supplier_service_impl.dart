import 'package:back_end_cuidapet/app/modules/supplier/view_models/create_supplier_user_view_model.dart';
import 'package:back_end_cuidapet/entities/supplier.dart';
import 'package:back_end_cuidapet/entities/supplier_business.dart';
import 'package:injectable/injectable.dart';

import 'package:back_end_cuidapet/app/modules/supplier/data/supplier_repository.dart';
import 'package:back_end_cuidapet/dtos/supplier_near_by_me_dto.dart';

import './supplier_service.dart';

@LazySingleton(as: SupplierService)
class SupplierServiceImpl implements SupplierService {
  final SupplierRepository _supplierRepository;
  static final distance = 5;

  SupplierServiceImpl({
    required SupplierRepository supplierRepository,
  }) : _supplierRepository = supplierRepository;

  @override
  Future<List<SupplierNearByMeDto>> findNearByMe(double lat, double lng) =>
      _supplierRepository.findNearByPosition(lat, lng, distance);

  @override
  Future<Supplier?> findById(int id) => _supplierRepository.findById(id);

  @override
  Future<List<SupplierBusiness>> findBusinessBySupplier(int supplierId) =>
      _supplierRepository.findBusinessBySupplierId(supplierId);

  @override
  Future<bool> checkUserEmailExists(String email) =>
      _supplierRepository.checkUserEmailExists(email);

  @override
  Future<void> createSupplierUser(CreateSupplierUserViewModel model) {
    // TODO: implement createSupplierUser
    throw UnimplementedError();
  }
}

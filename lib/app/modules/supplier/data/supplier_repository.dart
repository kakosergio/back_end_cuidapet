import 'package:back_end_cuidapet/dtos/supplier_near_by_me_dto.dart';

abstract interface class SupplierRepository {
  Future<List<SupplierNearByMeDto>> findNearByPosition(double lat, double lng, int distance);
}
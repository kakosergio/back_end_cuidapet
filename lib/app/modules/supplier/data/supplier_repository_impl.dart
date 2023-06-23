import 'package:back_end_cuidapet/app/exceptions/database_exception.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import 'package:back_end_cuidapet/app/database/database_connection.dart';
import 'package:back_end_cuidapet/app/logger/logger.dart';
import 'package:back_end_cuidapet/dtos/supplier_near_by_me_dto.dart';

import './supplier_repository.dart';

@LazySingleton(as: SupplierRepository)
class SupplierRepositoryImpl implements SupplierRepository {
  DatabaseConnection _connection;
  Logger _log;

  SupplierRepositoryImpl({
    required DatabaseConnection connection,
    required Logger log,
  })  : _connection = connection,
        _log = log;

  @override
  Future<List<SupplierNearByMeDto>> findNearByPosition(
      double lat, double lng, int distance) async {
    MySqlConnection? conn;

    try {
      conn = await _connection.openConnection();
      await conn.query('''
        SELECT f.id, f.nome, f.logo, f.categorias_fornecedor_id, 
          (6371 * 
            acos( 
                      cos(radians($lat)) * 
                      cos(radians(ST_X(f.latlng))) * 
                      cos(radians($lng) - radians(ST_Y(f.latlng))) + 
                      sin(radians($lat)) * 
                      sin(radians(ST_X(f.latlng))) 
                )) AS distancia 
            FROM fornecedor f 
            HAVING distancia <= $distance;
        ''');
    } on MySqlException catch (e, s) {
      _log.error('Erro ao buscar os fornecedores próximos', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}

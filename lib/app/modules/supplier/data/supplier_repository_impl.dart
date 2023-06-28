import 'package:back_end_cuidapet/app/exceptions/database_exception.dart';
import 'package:back_end_cuidapet/entities/category.dart';
import 'package:back_end_cuidapet/entities/supplier.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import 'package:back_end_cuidapet/app/database/database_connection.dart';
import 'package:back_end_cuidapet/app/logger/logger.dart';
import 'package:back_end_cuidapet/dtos/supplier_near_by_me_dto.dart';

import './supplier_repository.dart';

@LazySingleton(as: SupplierRepository)
class SupplierRepositoryImpl implements SupplierRepository {
  final DatabaseConnection _connection;
  final Logger _log;

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
      final result = await conn.query('''
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
      return result
          .map((e) => SupplierNearByMeDto(
              id: e['id'],
              name: e['nome'],
              logo: (e['logo'] as Blob?)?.toString(),
              distance: e['distancia'],
              categoryId: e['categorias_fornecedor_id']))
          .toList();
    } on MySqlException catch (e, s) {
      _log.error('Erro ao buscar os fornecedores próximos', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<Supplier?> findById(int id) async {
    MySqlConnection? conn;

    try {
      conn = await _connection.openConnection();
      final String query = '''
        SELECT 
          f.id, f.nome, f.logo, f.endereco, f.telefone, ST_X(f.latlng) as lat, ST_Y(f.latlng) as lng, 
          f.categorias_fornecedor_id, c.nome_categoria, c.tipo_categoria
        FROM fornecedor as f
          INNER JOIN categorias_fornecedores c on (f.categorias_fornecedor_id = c.id)
        WHERE 
          f.id = ?
      ''';

      final result = await conn.query(query);

      if (result.isNotEmpty) {
        final supplier = result.first;

        return Supplier(
          id: supplier['id'],
          name: supplier['nome'],
          logo: (supplier['logo'] as Blob?).toString(),
          address: supplier['endereco'],
          phone: supplier['telefone'],
          lat: supplier['lat'],
          lng: supplier['lng'],
          category: Category(
            id: supplier['categorias_fornecedor_id'],
            name: supplier['nome_categoria'],
            type: supplier['tipo_categoria'],
          ),
        );
      }
      return null;
    } on MySqlException catch (e, s) {
      _log.error('Erro ao buscar id do fornecedor', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}

import 'package:back_end_cuidapet/app/exceptions/database_exception.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import 'package:back_end_cuidapet/app/database/database_connection.dart';
import 'package:back_end_cuidapet/app/logger/logger.dart';
import 'package:back_end_cuidapet/entities/category.dart';

import './categories_repository.dart';

@LazySingleton(as: CategoriesRepository)
class CategoriesRepositoryImpl implements CategoriesRepository {
  final DatabaseConnection _connection;
  final Logger _log;

  CategoriesRepositoryImpl({
    required DatabaseConnection connection,
    required Logger log,
  })  : _connection = connection,
        _log = log;

  @override
  Future<List<Category>> findAll() async {
    MySqlConnection? conn;

    try {
      conn = await _connection.openConnection();
      final result = await conn.query('SELECT * FROM categorias_fornecedor');

      if (result.isNotEmpty) {
        return result
            .map(
              (e) => Category(
                id: e['id'],
                name: e['nome_categoria'],
                type: e['tipo_categoria'],
              ),
            )
            .toList();
      }
      return [];
    } on MySqlException catch (e, s) {
      _log.error('Erro ao buscar todas as categorias no banco de dados', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}

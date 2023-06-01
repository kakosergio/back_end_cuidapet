import 'package:back_end_cuidapet/app/database/database_connection.dart';
import 'package:back_end_cuidapet/app/exceptions/database_exception.dart';
import 'package:back_end_cuidapet/app/exceptions/user_exists_exception.dart';
import 'package:back_end_cuidapet/app/exceptions/user_not_found_exception.dart';
import 'package:back_end_cuidapet/app/helpers/sha256_hash_generator.dart';
import 'package:back_end_cuidapet/app/logger/logger.dart';
import 'package:back_end_cuidapet/app/modules/user/data/user_repository.dart';
import 'package:back_end_cuidapet/entities/user.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final DatabaseConnection _connection;
  final Logger _log;

  UserRepositoryImpl({
    required DatabaseConnection connection,
    required Logger log,
  })  : _connection = connection,
        _log = log;

  @override
  Future<User> create(User user) async {
    late final MySqlConnection? conn;

    try {
      conn = await _connection.openConnection();
      final query =
          '''INSERT usuario(email, tipo_cadastro, img_avatar, senha, fornecedor_id, social_id)
      values(?, ?, ?, ?, ?, ?)
       ''';

      final result = await conn.query(query, [
        user.email,
        user.registerType,
        user.imageAvatar,
        Sha256HashGenerator.generate(user.password ?? ''),
        user.supplierId,
        user.socialKey
      ]);

      final userId = result.insertId;
      return user.copyWith(id: userId, password: null);
    } on MySqlException catch (e, s) {
      if (e.message.contains('usuario.email_UNIQUE')) {
        _log.error('Usuario ja cadastrado na base de dados', e, s);
        throw UserExistsException();
      }
      _log.error('Erro ao criar o usuario', e, s);
      throw DatabaseException(message: 'Erro ao criar o usuario', exception: e);
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<User> login(String email, String password, bool supplierUser) async {
    late MySqlConnection conn;

    try {
      conn = await _connection.openConnection();
      var query = '''
          SELECT *
          FROM usuario
          WHERE
            email = ? AND
            senha = ?
          ''';
      if (supplierUser) {
        query += ' AND fornecedor_id IS NOT NULL';
      } else {
        query += ' AND fornecedor_id IS NULL';
      }
      final result = await conn.query(query, [
        email,
        Sha256HashGenerator.generate(password),
      ]);

      if (result.isEmpty) {
        _log.error('usuario ou senha invalidos');
        throw UserNotFoundException(message: 'Usuário ou senha inválidos');
      } else {
        final userSqlData = result.first;
        return User(
          id: userSqlData['id'],
          email: userSqlData['email'],
          registerType: userSqlData['tipo_cadastro'],
          iosToken: (userSqlData['ios_token'] as Blob?).toString(),
          androidToken: (userSqlData['android_token'] as Blob?).toString(),
          refreshToken: (userSqlData['refresh_token'] as Blob?).toString(),
          imageAvatar: (userSqlData['img_avatar'] as Blob?).toString(),
          supplierId: userSqlData['fornecedor_id'],
        );
      }
    } on MySqlException catch (e, s) {
      _log.error('erro ao realizar login', e, s);
      throw DatabaseException(message: e.message);
    } finally {
      await conn.close();
    }
  }
}

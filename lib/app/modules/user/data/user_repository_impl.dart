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
  Future<User> emailLogin(
      String email, String password, bool supplierUser) async {
    late MySqlConnection conn;

    try {
      conn = await _connection.openConnection();
      // Seleciona todos os usuários que tiverem esse e-mail e essa senha passada
      // Como o e-mail é UNIQUE no banco de dados, será retornado só um valor
      // O legal é que se o e-mail ou a senha não baterem, ele nunca vai retor-
      // nar um valor. Muito bom!
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

  @override
  Future<User> socialLogin(
      String email, String socialKey, String socialType) async {
    late MySqlConnection conn;

    try {
      conn = await _connection.openConnection();
      final result =
          await conn.query('SELECT * FROM usuario WHERE email = ?', [email]);

      if (result.isEmpty) {
        throw UserNotFoundException(message: 'Usuario não encontrado');
      } else {
        final dataMySql = result.first;
        if (dataMySql['social_id'] == null ||
            dataMySql['social_id'] != socialKey) {
          await conn.query(
            '''UPDATE usuario 
            SET social_id = ?, tipo_cadastro = ? 
            WHERE id = ?''',
            [
              socialKey,
              socialType,
              dataMySql['id'],
            ],
          );
        }
        return User(
          id: dataMySql['id'],
          email: dataMySql['email'],
          registerType: dataMySql['tipo_cadastro'],
          iosToken: (dataMySql['ios_token'] as Blob?).toString(),
          androidToken: (dataMySql['android_token'] as Blob?).toString(),
          refreshToken: (dataMySql['refresh_token'] as Blob?).toString(),
          imageAvatar: (dataMySql['img_avatar'] as Blob?).toString(),
          supplierId: dataMySql['fornecedor_id'],
        );
      }
    } on MySqlException catch (e, s) {
      _log.error('Erro ao realizar login', e, s);
      throw DatabaseException();
    } finally {
      await conn.close();
    }
  }

  @override
  Future<void> updateUserDeviceAndRefreshToken(User user) async {
    MySqlConnection? conn;

    try {
      conn = await _connection.openConnection();

      final setParams = <String, String?>{};

      if (user.iosToken != null) {
        setParams['ios_token'] = user.iosToken;
        // setParams.putIfAbsent('ios_token', () => user.iosToken);
      } else {
        setParams['android_token'] = user.androidToken;
        // setParams.putIfAbsent('android_token', () => user.androidToken);
      }

      final query = '''
        UPDATE usuario
        SET
          ${setParams.keys.first} = ?,
          refresh_token = ?
        WHERE
          id = ?
      ''';
      await conn
          .query(query, [setParams.values.first, user.refreshToken, user.id]);
    } on MySqlException catch (e, s) {
      _log.error('Erro ao confirmar login', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<void> updateRefreshToken(User user) async {
    MySqlConnection? conn;

    try {
      conn = await _connection.openConnection();
      await conn.query('UPDATE usuario SET refresh_token = ? WHERE id = ?', [
        user.refreshToken,
        user.id,
      ]);
    } on MySqlException catch (e, s) {
      _log.error('Erro ao atualizar o refresh token', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<User> findById(int id) async {
    MySqlConnection? conn;

    try {
      conn = await _connection.openConnection();
      final result = await conn.query('''
          SELECT * FROM usuario WHERE id = ?
      ''', [id]);

      if (result.isEmpty) {
        throw UserNotFoundException(message: 'User not found');
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
      _log.error('Erro ao buscar usuario por id', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<void> updateAvatar(String urlAvatar, int id) async {
    MySqlConnection? conn;
    try {
      conn = await _connection.openConnection();
      await conn.query(
        '''
         UPDATE usuario 
         SET img_avatar = ? 
         WHERE id = ?
      ''',
        [urlAvatar, id],
      );
    } on MySqlException catch (e, s) {
      _log.error('Erro ao atualizar url do avatar', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}

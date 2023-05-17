import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import 'package:back_end_cuidapet/app/config/database_connection_configuration.dart';
import 'package:back_end_cuidapet/app/database/database_connection.dart';

@LazySingleton(as: DatabaseConnection)
class DatabaseConnectionImpl implements DatabaseConnection {
  final DatabaseConnectionConfiguration _configuration;

  DatabaseConnectionImpl(this._configuration);

  @override
  Future<MySqlConnection> openConnection() {
    return MySqlConnection.connect(ConnectionSettings(
      host: _configuration.host,
      port: _configuration.port,
      user: _configuration.user,
      password: _configuration.password,
      db: _configuration.databaseName
    ));
  }
}

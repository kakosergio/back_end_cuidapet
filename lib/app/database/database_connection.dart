import 'package:mysql1/mysql1.dart';

abstract interface class DatabaseConnection {
  Future<MySqlConnection> openConnection();
}
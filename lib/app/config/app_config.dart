import 'package:back_end_cuidapet/app/config/database_connection_configuration.dart';
import 'package:back_end_cuidapet/app/config/service_locator_config.dart';
import 'package:back_end_cuidapet/app/logger/logger.dart';
import 'package:back_end_cuidapet/app/logger/logger_impl.dart';
import 'package:dotenv/dotenv.dart';
import 'package:get_it/get_it.dart';

// AppConfig instancia todas as configurações de banco de dados do aplicativo
class AppConfig {
  Future<void> loadAppConfig() async {
    await _loadEnv();
    _loadDatabaseConfig();
    _configLogger();
    _loadDependencies();
  }

  Future<void> _loadEnv() async => DotEnv().load;

  void _loadDatabaseConfig() {
    final databaseConfig = DatabaseConnectionConfiguration(
      host: DotEnv()['DATABASE_HOST'] ?? DotEnv()['databaseHost']!,
      user: DotEnv()['DATABASE_USER'] ?? DotEnv()['databaseUser']!,
      port: int.tryParse(
              DotEnv()['DATABASE_PORT'] ?? DotEnv()['databasePort']!) ??
          3306,
      password:
          DotEnv()['DATABASE_PASSWORD'] ?? DotEnv()['databasePassword'] ?? '',
      databaseName: DotEnv()['DATABASE_NAME'] ?? DotEnv()['databaseName'] ?? '',
    );

    // Registra a configuração do banco de dados no GetIt para injeção de dependência
    GetIt.I.registerSingleton(databaseConfig);
  }

  void _configLogger() =>
      GetIt.I.registerLazySingleton<Logger>(() => LoggerImpl());

  void _loadDependencies() => configureDependencies();
}

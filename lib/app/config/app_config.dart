import 'package:back_end_cuidapet/app/config/database_connection_configuration.dart';
import 'package:back_end_cuidapet/app/config/environments.dart';
import 'package:back_end_cuidapet/app/config/service_locator_config.dart';
import 'package:back_end_cuidapet/app/logger/logger.dart';
import 'package:back_end_cuidapet/app/logger/logger_impl.dart';
import 'package:get_it/get_it.dart';

// AppConfig instancia todas as configurações de banco de dados do aplicativo
class AppConfig {
  Future<void> loadAppConfig() async {
    _loadEnv();
    _loadDatabaseConfig();
    _configLogger();
    _loadDependencies();
  }

  void _loadEnv() async =>
      GetIt.I.registerSingleton<Environments>(Environments()..loadEnvs());

  void _loadDatabaseConfig() {
    // Com o novo singleton registrado na classe Environments, recuperei a instancia pelo GetIt
    // e passei a nova função param direto no databaseConfig.
    // Agora vamos executar e ver no que dá
    var env = GetIt.I.get<Environments>();
    final databaseConfig = DatabaseConnectionConfiguration(
      host: env.param('DATABASE_HOST') ?? env.param('dbHost')!,
      user: env.param('DATABASE_USER') ?? env.param('dbUser')!,
      port: int.tryParse(env.param('DATABASE_PORT') ?? env.param('dbPort')!) ?? 3306,
      password: env.param('DATABASE_PASSWORD') ?? env.param('dbPassword') ?? '',
      databaseName: env.param('DATABASE_NAME') ?? env.param('dbName') ?? '',
    );

    // Registra a configuração do banco de dados no GetIt para injeção de dependência
    GetIt.I.registerSingleton(databaseConfig);
  }

  void _configLogger() =>
      GetIt.I.registerLazySingleton<Logger>(() => LoggerImpl());

  void _loadDependencies() => configureDependencies();
}

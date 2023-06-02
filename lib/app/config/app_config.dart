import 'package:back_end_cuidapet/app/config/database_connection_configuration.dart';
import 'package:back_end_cuidapet/app/config/environments.dart';
import 'package:back_end_cuidapet/app/config/service_locator_config.dart';
import 'package:back_end_cuidapet/app/logger/logger.dart';
import 'package:back_end_cuidapet/app/logger/logger_impl.dart';
import 'package:back_end_cuidapet/app/routers/router_config.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/shelf_router.dart';

// AppConfig instancia todas as configurações do aplicativo
class AppConfig {
  Future<void> loadAppConfig(Router router) async {
    _loadEnv();
    _loadDatabaseConfig();
    _configLogger();
    _loadDependencies();
    _loadRoutersConfig(router);
  }

  void _loadEnv() async =>
      GetIt.I.registerSingleton<Environments>(Environments()..loadEnvs());

  void _loadDatabaseConfig() {
    // Com o novo singleton registrado na classe Environments, recuperei a instancia pelo GetIt
    // e passei a nova função param direto no databaseConfig. Com o override do operator []
    // indicando a função params como mediadora, basta passar nos colchetes os parametros
    // que ele trará as informações do dotenv corretamente.
    var env = GetIt.I.get<Environments>();
    final databaseConfig = DatabaseConnectionConfiguration(
      host: env['DATABASE_HOST'] ?? env['dbHost']!,
      user: env['DATABASE_USER'] ?? env['dbUser']!,
      port: int.tryParse(env['DATABASE_PORT'] ?? env['dbPort']!) ?? 3306,
      password: env['DATABASE_PASSWORD'] ?? env['dbPassword'] ?? '',
      databaseName: env['DATABASE_NAME'] ?? env['dbName'] ?? '',
    );

    // Registra a configuração do banco de dados no GetIt para injeção de dependência
    GetIt.I.registerSingleton(databaseConfig);
  }

  void _configLogger() =>
      GetIt.I.registerLazySingleton<Logger>(() => LoggerImpl());

  void _loadDependencies() => configureDependencies();

  void _loadRoutersConfig(Router router) => RouterConfig(router).configure();

}

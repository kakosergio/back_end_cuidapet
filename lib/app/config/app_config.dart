import 'package:back_end_cuidapet/app/config/database_connection_configuration.dart';
import 'package:back_end_cuidapet/app/config/service_locator_config.dart';
import 'package:back_end_cuidapet/app/logger/logger.dart';
import 'package:back_end_cuidapet/app/logger/logger_impl.dart';
import 'package:dotenv/dotenv.dart';
import 'package:get_it/get_it.dart';

// AppConfig instancia todas as configurações de banco de dados do aplicativo
class AppConfig {
  Future<void> loadAppConfig() async {
    // Como feito na aula, mas não serviu para a versão atual do Dotenv e Dart
    // _loadEnv();
    _loadDatabaseConfig();
    _configLogger();
    _loadDependencies();
  }

  // Como feito na aula, mas não serviu para a versão atual do Dotenv e Dart
  // Talvez com o flutter_dotenv resolvesse
  // Future<void> _loadEnv() async => DotEnv()..load();

  void _loadDatabaseConfig() {
    // Seguindo a documentação, o carregamento do DotEnv foi realizado
    // Detalhe: a função load do DotEnv não retorna um Future, então o carregamento
    // pôde ser feito de forma síncrona.
    var env = DotEnv()..load();
    final databaseConfig = DatabaseConnectionConfiguration(
      host: env['DATABASE_HOST'] ?? env['dbHost']!,
      user: env['DATABASE_USER'] ?? env['dbUser']!,
      port: int.tryParse(env['DATABASE_PORT'] ?? env['dbPort']!) ??
          3306,
      password: env['DATABASE_PASSWORD'] ?? env['dbPassword'] ?? '',
      databaseName: env['DATABASE_NAME'] ?? env['dbName'] ?? '',
    );

    // Registra a configuração do banco de dados no GetIt para injeção de dependência
    GetIt.I.registerSingleton(databaseConfig);
  }

  void _configLogger() =>
      GetIt.I.registerLazySingleton<Logger>(() => LoggerImpl());

  void _loadDependencies() => configureDependencies();
}

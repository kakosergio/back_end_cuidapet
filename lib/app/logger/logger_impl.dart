import 'package:back_end_cuidapet/app/logger/logger.dart';
import 'package:logger/logger.dart' as log;

class LoggerImpl implements Logger {
  final _logger = log.Logger();

  @override
  void debug(message, [error, StackTrace? stackTrace]) =>
      _logger.d(message, error, stackTrace);

  @override
  void error(message, [error, StackTrace? stackTrace]) =>
      _logger.e(message, error, stackTrace);

  @override
  void info(message, [error, StackTrace? stackTrace]) =>
      _logger.i(message, error, stackTrace);

  @override
  void warning(message, [error, StackTrace? stackTrace]) =>
      _logger.w(message, error, stackTrace);
      
}

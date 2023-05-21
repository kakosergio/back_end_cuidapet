import 'package:shelf/shelf.dart';

abstract class Middlewares {
  late Handler innerHandler;

  Handler call(Handler innerHandler) {
    this.innerHandler = innerHandler;
    return execute;
  }

  Future<Response> execute(Request request);
}

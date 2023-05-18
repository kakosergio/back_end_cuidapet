import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'controller.g.dart';

class Controller {
  @Route.get('/')
  Response hello(Request request) {
    return Response.ok('Hello Kako');
  }

  Router get router => _$ControllerRouter(this);
}

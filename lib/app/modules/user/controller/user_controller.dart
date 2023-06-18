import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'user_controller.g.dart';

@Injectable()
class UserController {

   @Route.get('/')
   Future<Response> findByToken(Request request) async { 
      return Response.ok(jsonEncode(''));
   }

   Router get router => _$UserControllerRouter(this);
}
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:back_end_cuidapet/app/exceptions/user_not_found_exception.dart';
import 'package:back_end_cuidapet/app/logger/logger.dart';
import 'package:back_end_cuidapet/app/modules/user/service/user_service.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'user_controller.g.dart';

@Injectable()
class UserController {
  final UserService _userService;
  final Logger _log;

  UserController({required UserService userService, required Logger log})
      : _userService = userService,
        _log = log;

  @Route.get('/')
  Future<Response> findByToken(Request request) async {
    try {
      final id = int.parse(request.headers['user']!);

      final user = await _userService.findById(id);
      return Response.ok(
        jsonEncode(
          {
            'email': user.email,
            'register_type': user.registerType,
            'img_avatar': user.imageAvatar,
          },
        ),
      );
    } on UserNotFoundException catch (e, s) {
      _log.error('User not found', e, s);
      return Response(HttpStatus.noContent,
          body: json.encode({'message': 'user not found'}));
    } catch (e, s) {
      _log.error('Error', e, s);
      return Response.internalServerError(
          body: jsonEncode({'message': 'Error finding user'}));
    }
  }

  Router get router => _$UserControllerRouter(this);
}

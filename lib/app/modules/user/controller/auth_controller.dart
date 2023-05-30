import 'dart:async';
import 'dart:convert';

import 'package:back_end_cuidapet/app/exceptions/user_exists_exception.dart';
import 'package:back_end_cuidapet/app/logger/logger.dart';
import 'package:back_end_cuidapet/app/modules/user/view_models/user_save_input_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:back_end_cuidapet/app/modules/user/service/user_service.dart';

part 'auth_controller.g.dart';

@Injectable()
class AuthController {
  final UserService _userService;
  final Logger _log;

  AuthController({required UserService userService, required Logger log})
      : _userService = userService,
        _log = log;

  @Route.post('/register')
  Future<Response> saveUser(Request request) async {
    try {
      final userModel = UserSaveInputModel(await request.readAsString());
      await _userService.createUser(userModel);
      return Response.ok(
          jsonEncode({'message': 'Cadastro realizado com sucesso'}));
    } on UserExistsException {
      return Response.badRequest(
          body: jsonEncode(
              {'message': 'usuario ja cadastrado na base de dados'}));
    } catch (e) {
      _log.error('Erro ao cadastrar usuario', e);
      return Response.internalServerError();
    }
  }

  Router get router => _$AuthControllerRouter(this);
}

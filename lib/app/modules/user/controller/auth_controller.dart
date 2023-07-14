import 'dart:async';
import 'dart:convert';

import 'package:back_end_cuidapet/app/exceptions/user_exists_exception.dart';
import 'package:back_end_cuidapet/app/exceptions/user_not_found_exception.dart';
import 'package:back_end_cuidapet/app/helpers/jwt_helper.dart';
import 'package:back_end_cuidapet/app/logger/logger.dart';
import 'package:back_end_cuidapet/app/modules/user/view_models/login_view_model.dart';
import 'package:back_end_cuidapet/app/modules/user/view_models/user_confirm_input_model.dart';
import 'package:back_end_cuidapet/app/modules/user/view_models/user_refresh_token_input_model.dart';
import 'package:back_end_cuidapet/app/modules/user/view_models/user_save_input_model.dart';
import 'package:back_end_cuidapet/entities/user.dart';
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

  @Route.post('/')
  Future<Response> login(Request request) async {
    try {
      final loginViewModel = LoginViewModel(await request.readAsString());

      User user;

      if (!loginViewModel.socialLogin) {
        user = await _userService.emailLogin(loginViewModel.email,
            loginViewModel.password, loginViewModel.supplierUser);
      } else {
        user = await _userService.socialLogin(
            loginViewModel.email,
            loginViewModel.avatar,
            loginViewModel.socialType,
            loginViewModel.socialKey);
      }

      return Response.ok(jsonEncode(
          {'access_token': JwtHelper.generateJWT(user.id!, user.supplierId)}));
    } on UserNotFoundException {
      return Response.forbidden(
          jsonEncode({'message': 'Usuário ou senha inválidos'}));
    } catch (e, s) {
      _log.error('Erro ao fazer login', e, s);
      return Response.internalServerError(
          body: jsonEncode({'message': 'Erro ao realizar login'}));
    }
  }

  @Route.post('/register')
  Future<Response> saveUser(Request request) async {
    try {
      final userModel = UserSaveInputModel.requestMapping(await request.readAsString());
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

  @Route('PATCH', '/confirm')
  Future<Response> confirmLogin(Request request) async {
    final userId = int.parse(request.headers['user']!);
    final supplierId = int.tryParse(request.headers['supplier'] ?? '');
    // final token = JwtHelper.generateJWT(userId, supplierId); - passado para a camada de services

    final inputModel = UserConfirmInputModel(await request.readAsString(),
        userId: userId, supplierId: supplierId);

    final (accessToken, refreshToken) =
        await _userService.confirmLogin(inputModel);

    return Response.ok(
      jsonEncode(
        {
          'access_token': accessToken,
          'refresh_token': refreshToken,
        },
      ),
    );
  }

  @Route.put('/refresh')
  Future<Response> refreshToken(Request request) async {
    try {
      final user = int.parse(request.headers['user']!);
      final supplier = int.tryParse(request.headers['supplier'] ?? '');
      final accessToken = request.headers['access_token']!;
      final model = UserRefreshTokenInputModel(await request.readAsString(),
          user: user, accessToken: accessToken, supplier: supplier);

      final userRefreshToken = await _userService.refreshToken(model);

      return Response.ok(
        jsonEncode(
          {
            'access_token': userRefreshToken.accessToken,
            'refresh_token': userRefreshToken.refreshToken
          },
        ),
      );
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'message': 'Erro ao atualizar token'}));
    }
  }

  Router get router => _$AuthControllerRouter(this);
}

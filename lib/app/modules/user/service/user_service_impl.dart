import 'package:back_end_cuidapet/app/exceptions/service_exception.dart';
import 'package:back_end_cuidapet/app/exceptions/user_not_found_exception.dart';
import 'package:back_end_cuidapet/app/helpers/jwt_helper.dart';
import 'package:back_end_cuidapet/app/modules/user/view_models/refresh_token_view_model.dart';
import 'package:back_end_cuidapet/app/modules/user/view_models/update_device_token_input_model.dart';
import 'package:back_end_cuidapet/app/modules/user/view_models/update_url_avatar_view_model.dart';
import 'package:back_end_cuidapet/app/modules/user/view_models/user_confirm_input_model.dart';
import 'package:back_end_cuidapet/app/modules/user/view_models/user_refresh_token_input_model.dart';
import 'package:injectable/injectable.dart';

import 'package:back_end_cuidapet/app/modules/user/data/user_repository.dart';
import 'package:back_end_cuidapet/app/modules/user/service/user_service.dart';
import 'package:back_end_cuidapet/app/modules/user/view_models/user_save_input_model.dart';
import 'package:back_end_cuidapet/entities/user.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../../../logger/logger.dart';

@LazySingleton(as: UserService)
class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final Logger _log;

  UserServiceImpl({
    required UserRepository userRepository,
    required Logger log,
  })  : _userRepository = userRepository,
        _log = log;

  @override
  Future<User> createUser(UserSaveInputModel user) {
    final userEntity = User(
        email: user.email,
        password: user.password,
        registerType: 'App',
        supplierId: user.supplierId);

    return _userRepository.create(userEntity);
  }

  @override
  Future<User> emailLogin(String email, String password, bool supplierUser) =>
      _userRepository.emailLogin(email, password, supplierUser);

  @override
  Future<User> socialLogin(
      String email, String avatar, String socialType, String socialKey) async {
    try {
      return await _userRepository.socialLogin(email, socialKey, socialType);
    } on UserNotFoundException catch (e) {
      _log.info('Usuario não encontrado, criando um novo', e);
      final user = User(
          email: email,
          imageAvatar: avatar,
          registerType: socialType,
          socialKey: socialKey,
          password: DateTime.now().toString());

      return await _userRepository.create(user);
    }
  }

  @override
  Future<(String, String)> confirmLogin(
      UserConfirmInputModel inputModel) async {
    final accessToken =
        JwtHelper.generateJWT(inputModel.userId, inputModel.supplierId)
            .replaceAll('Bearer ', '');
    final refreshToken = JwtHelper.refreshToken(accessToken);
    final user = User(
        id: inputModel.userId,
        refreshToken: refreshToken,
        iosToken: inputModel.iosDeviceToken,
        androidToken: inputModel.androidDeviceToken);
    await _userRepository.updateUserDeviceAndRefreshToken(user);
    return ('Bearer $accessToken', refreshToken);
  }

  @override
  Future<RefreshTokenViewModel> refreshToken(
      UserRefreshTokenInputModel model) async {
    _validateRefreshToken(model);
    final newAccessToken = JwtHelper.generateJWT(model.user, model.supplier);
    final newRefreshToken =
        JwtHelper.refreshToken(newAccessToken.replaceAll('Bearer ', ''));

    final user = User(
      id: model.user,
      refreshToken: newRefreshToken,
    );
    await _userRepository.updateRefreshToken(user);

    return RefreshTokenViewModel(
        accessToken: newAccessToken, refreshToken: newRefreshToken);
  }

  void _validateRefreshToken(UserRefreshTokenInputModel model) {
    const String error = 'Invalid Refresh Token';
    try {
      final refreshToken = model.refreshToken.split(' ');

      if (refreshToken.length != 2 || refreshToken.first != 'Bearer') {
        _log.error(error);
        throw ServiceException(error);
      }
      final refreshTokenClaims = JwtHelper.getClaims(refreshToken.last);
      refreshTokenClaims.validate(issuer: model.accessToken);
    } on ServiceException {
      rethrow;
    } on JwtException catch (e, s) {
      _log.error(error, e, s);
      throw ServiceException(error);
    } catch (e) {
      throw ServiceException('Error validating Refresh Token');
    }
  }

  @override
  Future<User> findById(int id) => _userRepository.findById(id);

  @override
  Future<User> updateAvatar(UpdateUrlAvatarViewModel viewModel) async {
    await _userRepository.updateAvatar(viewModel.urlAvatar, viewModel.userId);
    return findById(viewModel.userId);
  }

  @override
  Future<void> updateDeviceToken(UpdateDeviceTokenInputModel model) =>
      _userRepository.updateDeviceToken(
          model.userId, model.deviceToken, model.platform);
}

import 'package:back_end_cuidapet/app/exceptions/user_not_found_exception.dart';
import 'package:injectable/injectable.dart';

import 'package:back_end_cuidapet/app/modules/user/data/user_repository.dart';
import 'package:back_end_cuidapet/app/modules/user/service/user_service.dart';
import 'package:back_end_cuidapet/app/modules/user/view_models/user_save_input_model.dart';
import 'package:back_end_cuidapet/entities/user.dart';

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
}

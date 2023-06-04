import 'package:injectable/injectable.dart';

import 'package:back_end_cuidapet/app/modules/user/data/user_repository.dart';
import 'package:back_end_cuidapet/app/modules/user/service/user_service.dart';
import 'package:back_end_cuidapet/app/modules/user/view_models/user_save_input_model.dart';
import 'package:back_end_cuidapet/entities/user.dart';

@LazySingleton(as: UserService)
class UserServiceImpl implements UserService {
  final UserRepository _userRepository;

  UserServiceImpl({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

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
        Future<User> socialLogin(String email, String avatar, String socialType, String socialKey) {
          // TODO: implement socialLogin
          throw UnimplementedError();
        }
}

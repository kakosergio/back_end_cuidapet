import 'package:injectable/injectable.dart';

import 'package:back_end_cuidapet/app/modules/user/data/user_repository.dart';
import 'package:back_end_cuidapet/app/modules/user/service/user_service.dart';
import 'package:back_end_cuidapet/app/modules/user/view_models/user_save_input_model.dart';
import 'package:back_end_cuidapet/entities/user.dart';

@LazySingleton(as: UserService)
class UserServiceImpl implements UserService {
  final UserRepository userRepository;

  UserServiceImpl({
    required this.userRepository,
  });

  @override
  Future<User> createUser(UserSaveInputModel user) {
    final userEntity = User(
        email: user.email,
        password: user.password,
        registerType: 'App',
        supplierId: user.supplierId);

    return userRepository.create(userEntity);
  }
}

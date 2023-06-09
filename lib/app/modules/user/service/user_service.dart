import 'package:back_end_cuidapet/app/modules/user/view_models/user_confirm_input_model.dart';
import 'package:back_end_cuidapet/app/modules/user/view_models/user_save_input_model.dart';
import 'package:back_end_cuidapet/entities/user.dart';

abstract interface class UserService {
  Future<User> createUser(UserSaveInputModel user);
  Future<User> emailLogin(String email, String password, bool supplierUser);
  Future<User> socialLogin(
      String email, String avatar, String socialType, String socialKey);
  Future<(String accessToken, String refreshToken)> confirmLogin(UserConfirmInputModel inputModel);
}

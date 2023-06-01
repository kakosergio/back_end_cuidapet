import 'package:back_end_cuidapet/app/modules/user/view_models/user_save_input_model.dart';
import 'package:back_end_cuidapet/entities/user.dart';

abstract interface class UserService {
  Future<User> createUser(UserSaveInputModel user);
  Future<User> login(String email, String password, bool supplierUser);
}

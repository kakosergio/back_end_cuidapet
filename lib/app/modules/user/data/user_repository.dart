import '../../../../entities/user.dart';

abstract interface class UserRepository {
  Future<User> create(User user);
  Future<User> login(String email, String password, bool supplierUser);
}

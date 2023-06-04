import '../../../../entities/user.dart';

abstract interface class UserRepository {
  Future<User> create(User user);
  Future<User> emailLogin(String email, String password, bool supplierUser);
  Future<User> socialLogin(String email, String socialKey, bool socialType);
}

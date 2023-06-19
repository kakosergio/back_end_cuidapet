import '../../../../entities/user.dart';

abstract interface class UserRepository {
  Future<User> create(User user);
  Future<User> emailLogin(String email, String password, bool supplierUser);
  Future<User> socialLogin(String email, String socialKey, String socialType);
  Future<void> updateUserDeviceAndRefreshToken(User user);
  Future<void> updateRefreshToken(User user);
  Future<User> findById(int id);
  Future<void> updateAvatar(String urlAvatar, int id);
}

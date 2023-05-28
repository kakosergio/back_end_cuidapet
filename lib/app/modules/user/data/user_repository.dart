import '../../../../entities/user.dart';

abstract interface class UserRepository {
  Future<User> create(User user);
}

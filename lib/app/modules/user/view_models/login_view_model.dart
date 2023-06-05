import 'package:back_end_cuidapet/app/helpers/request_mapping_helper.dart';

class LoginViewModel extends RequestMappingHelper {
  late String email;
  late String password;
  late bool socialLogin;
  late String avatar;
  late String socialType;
  late String socialKey;
  late bool supplierUser;

  LoginViewModel(super.dataRequest);

  @override
  void map() {
    email = data['email'];
    password = data['password'];
    socialLogin = data['social_login'];
    avatar = data['avatar'];
    socialType = data['social_type'];
    socialKey = data['social_key'];
    supplierUser = data['supplier_user'];
  }
}

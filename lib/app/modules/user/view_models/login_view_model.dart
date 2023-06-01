import 'package:back_end_cuidapet/app/helpers/request_mapping_helper.dart';

class LoginViewModel extends RequestMappingHelper {
  late String email;
  late String password;
  late bool socialLogin;

  LoginViewModel(super.dataRequest);

  @override
  void map() {
    email = data['login'];
    password = data['password'];
    socialLogin = data['social_login'];
  }
}

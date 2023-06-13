import 'package:back_end_cuidapet/app/helpers/request_mapping.dart';

class UserRefreshTokenInputModel extends RequestMapping {
  int user;
  int? supplier;
  String accessToken;
  late String refreshToken;

  UserRefreshTokenInputModel(
    super.dataRequest, {
    required this.user,
    this.supplier,
    required this.accessToken,
  });

  @override
  void map() {
    refreshToken = data['refresh_token'];
  }
}

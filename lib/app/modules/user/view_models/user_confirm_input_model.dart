import 'package:back_end_cuidapet/app/helpers/request_mapping.dart';

class UserConfirmInputModel extends RequestMapping {
  final int userId;
  final String accessToken;
  late final String iosDeviceToken;
  late final String androidDeviceToken;

  UserConfirmInputModel(
    super.dataRequest, {
    required this.userId,
    required this.accessToken,
  });

  @override
  void map() {
    iosDeviceToken = data['ios_token'];
    androidDeviceToken = data['android_token'];
  }
}

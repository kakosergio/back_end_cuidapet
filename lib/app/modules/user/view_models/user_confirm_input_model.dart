import 'package:back_end_cuidapet/app/helpers/request_mapping.dart';

class UserConfirmInputModel extends RequestMapping {
  final int userId;
  final int? supplierId;
  late final String iosDeviceToken;
  late final String androidDeviceToken;

  UserConfirmInputModel(
    super.dataRequest, {
    required this.userId,
    required this.supplierId,
  });

  @override
  void map() {
    iosDeviceToken = data['ios_token'];
    androidDeviceToken = data['android_token'];
  }
}

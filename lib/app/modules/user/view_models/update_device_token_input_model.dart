import 'package:back_end_cuidapet/app/helpers/request_mapping.dart';
import 'package:back_end_cuidapet/app/modules/user/view_models/platform.dart';

class UpdateDeviceTokenInputModel extends RequestMapping {
  int userId;
  late Platform platform;
  late String deviceToken;

  UpdateDeviceTokenInputModel(
    super.dataRequest, {
    required this.userId,
  });

  @override
  void map() {
    deviceToken = data['device_token'];
    platform = data['platform'].toLowerCase() == 'ios'
        ? Platform.ios
        : Platform.android;
  }
}

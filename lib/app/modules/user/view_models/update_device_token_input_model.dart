import 'package:back_end_cuidapet/app/helpers/request_mapping.dart';
import 'package:back_end_cuidapet/app/modules/user/view_models/platform.dart';

class UpdateDeviceTokenInputModel extends RequestMapping {
  final Platform platform;
  late String deviceToken;

  UpdateDeviceTokenInputModel(
    super.dataRequest, {
    required this.platform,
  });

  @override
  void map() {
    deviceToken = data[platform.type];
  }
}

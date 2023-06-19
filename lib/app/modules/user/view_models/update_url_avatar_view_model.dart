import 'package:back_end_cuidapet/app/helpers/request_mapping.dart';

class UpdateUrlAvatarViewModel extends RequestMapping {
  late final String urlAvatar;
  final int userId;

  UpdateUrlAvatarViewModel(super.dataRequest, {required this.userId});
  @override
  void map() {
    urlAvatar = data['url_avatar'];
  }
}

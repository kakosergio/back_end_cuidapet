import 'package:back_end_cuidapet/app/helpers/request_mapping_helper.dart';

class UserSaveInputModel extends RequestMappingHelper {
  late String email;
  late String password;
  int? supplierId;

  UserSaveInputModel(String dataRequest) : super(dataRequest);

  @override
  void map() {
    email = data['email'];
    password = data['password'];
  }
}

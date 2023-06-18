import 'package:back_end_cuidapet/app/modules/user/controller/auth_controller.dart';
import 'package:back_end_cuidapet/app/modules/user/controller/user_controller.dart';
import 'package:back_end_cuidapet/app/routers/routers.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/shelf_router.dart';

class UserRouter implements Routers {
  @override
  void configure(Router router) {
    final authController = GetIt.I.get<AuthController>();
    final userController = GetIt.I.get<UserController>();

    router.mount('/auth/', authController.router);
    router.mount('/user/', userController.router);
  }
}

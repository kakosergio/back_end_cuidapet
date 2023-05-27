import 'package:back_end_cuidapet/app/modules/user/user_router.dart';
import 'package:back_end_cuidapet/app/routers/routers.dart';
import 'package:shelf_router/shelf_router.dart';

class RouterConfig {
  final Router _router;
  final List<Routers> _routers = [
    UserRouter(),
    
  ];

  RouterConfig(this._router);

  void configure() {
    for (var r in _routers) {
      r.configure(_router);
    }
  }
}

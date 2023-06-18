// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../database/database_connection.dart' as _i3;
import '../database/database_connection_impl.dart' as _i4;
import '../logger/logger.dart' as _i8;
import '../modules/user/controller/auth_controller.dart' as _i11;
import '../modules/user/controller/user_controller.dart' as _i12;
import '../modules/user/data/user_repository.dart' as _i6;
import '../modules/user/data/user_repository_impl.dart' as _i7;
import '../modules/user/service/user_service.dart' as _i9;
import '../modules/user/service/user_service_impl.dart' as _i10;
import 'database_connection_configuration.dart' as _i5;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i3.DatabaseConnection>(() =>
        _i4.DatabaseConnectionImpl(gh<_i5.DatabaseConnectionConfiguration>()));
    gh.lazySingleton<_i6.UserRepository>(() => _i7.UserRepositoryImpl(
          connection: gh<_i3.DatabaseConnection>(),
          log: gh<_i8.Logger>(),
        ));
    gh.lazySingleton<_i9.UserService>(() => _i10.UserServiceImpl(
          userRepository: gh<_i6.UserRepository>(),
          log: gh<_i8.Logger>(),
        ));
    gh.factory<_i11.AuthController>(() => _i11.AuthController(
          userService: gh<_i9.UserService>(),
          log: gh<_i8.Logger>(),
        ));
    gh.factory<_i12.UserController>(() => _i12.UserController(
          userService: gh<_i9.UserService>(),
          log: gh<_i8.Logger>(),
        ));
    return this;
  }
}

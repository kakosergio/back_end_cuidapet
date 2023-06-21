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

import '../database/database_connection.dart' as _i8;
import '../database/database_connection_impl.dart' as _i9;
import '../logger/logger.dart' as _i13;
import '../modules/categories/controller/categories_controller.dart' as _i3;
import '../modules/categories/data/categories_repository.dart' as _i4;
import '../modules/categories/data/categories_repository_impl.dart' as _i5;
import '../modules/categories/service/categories_service.dart' as _i6;
import '../modules/categories/service/categories_service_impl.dart' as _i7;
import '../modules/user/controller/auth_controller.dart' as _i16;
import '../modules/user/controller/user_controller.dart' as _i17;
import '../modules/user/data/user_repository.dart' as _i11;
import '../modules/user/data/user_repository_impl.dart' as _i12;
import '../modules/user/service/user_service.dart' as _i14;
import '../modules/user/service/user_service_impl.dart' as _i15;
import 'database_connection_configuration.dart' as _i10;

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
    gh.factory<_i3.CategoriesController>(() => _i3.CategoriesController());
    gh.lazySingleton<_i4.CategoriesRepository>(
        () => _i5.CategoriesRepositoryImpl());
    gh.lazySingleton<_i6.CategoriesService>(() => _i7.CategoriesServiceImpl());
    gh.lazySingleton<_i8.DatabaseConnection>(() =>
        _i9.DatabaseConnectionImpl(gh<_i10.DatabaseConnectionConfiguration>()));
    gh.lazySingleton<_i11.UserRepository>(() => _i12.UserRepositoryImpl(
          connection: gh<_i8.DatabaseConnection>(),
          log: gh<_i13.Logger>(),
        ));
    gh.lazySingleton<_i14.UserService>(() => _i15.UserServiceImpl(
          userRepository: gh<_i11.UserRepository>(),
          log: gh<_i13.Logger>(),
        ));
    gh.factory<_i16.AuthController>(() => _i16.AuthController(
          userService: gh<_i14.UserService>(),
          log: gh<_i13.Logger>(),
        ));
    gh.factory<_i17.UserController>(() => _i17.UserController(
          userService: gh<_i14.UserService>(),
          log: gh<_i13.Logger>(),
        ));
    return this;
  }
}

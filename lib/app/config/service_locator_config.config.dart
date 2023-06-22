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
import '../logger/logger.dart' as _i9;
import '../modules/categories/controller/categories_controller.dart' as _i18;
import '../modules/categories/data/categories_repository.dart' as _i13;
import '../modules/categories/data/categories_repository_impl.dart' as _i14;
import '../modules/categories/service/categories_service.dart' as _i15;
import '../modules/categories/service/categories_service_impl.dart' as _i16;
import '../modules/supplier/controller/supplier_controller.dart' as _i6;
import '../modules/user/controller/auth_controller.dart' as _i12;
import '../modules/user/controller/user_controller.dart' as _i17;
import '../modules/user/data/user_repository.dart' as _i7;
import '../modules/user/data/user_repository_impl.dart' as _i8;
import '../modules/user/service/user_service.dart' as _i10;
import '../modules/user/service/user_service_impl.dart' as _i11;
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
    gh.factory<_i6.SupplierController>(() => _i6.SupplierController());
    gh.lazySingleton<_i7.UserRepository>(() => _i8.UserRepositoryImpl(
          connection: gh<_i3.DatabaseConnection>(),
          log: gh<_i9.Logger>(),
        ));
    gh.lazySingleton<_i10.UserService>(() => _i11.UserServiceImpl(
          userRepository: gh<_i7.UserRepository>(),
          log: gh<_i9.Logger>(),
        ));
    gh.factory<_i12.AuthController>(() => _i12.AuthController(
          userService: gh<_i10.UserService>(),
          log: gh<_i9.Logger>(),
        ));
    gh.lazySingleton<_i13.CategoriesRepository>(
        () => _i14.CategoriesRepositoryImpl(
              connection: gh<_i3.DatabaseConnection>(),
              log: gh<_i9.Logger>(),
            ));
    gh.lazySingleton<_i15.CategoriesService>(() => _i16.CategoriesServiceImpl(
        categoriesRepository: gh<_i13.CategoriesRepository>()));
    gh.factory<_i17.UserController>(() => _i17.UserController(
          userService: gh<_i10.UserService>(),
          log: gh<_i9.Logger>(),
        ));
    gh.factory<_i18.CategoriesController>(() => _i18.CategoriesController(
          categoriesService: gh<_i15.CategoriesService>(),
          log: gh<_i9.Logger>(),
        ));
    return this;
  }
}

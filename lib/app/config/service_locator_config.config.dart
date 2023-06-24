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
import '../modules/categories/controller/categories_controller.dart' as _i22;
import '../modules/categories/data/categories_repository.dart' as _i16;
import '../modules/categories/data/categories_repository_impl.dart' as _i17;
import '../modules/categories/service/categories_service.dart' as _i18;
import '../modules/categories/service/categories_service_impl.dart' as _i19;
import '../modules/supplier/controller/supplier_controller.dart' as _i20;
import '../modules/supplier/data/supplier_repository.dart' as _i6;
import '../modules/supplier/data/supplier_repository_impl.dart' as _i7;
import '../modules/supplier/service/supplier_service.dart' as _i9;
import '../modules/supplier/service/supplier_service_impl.dart' as _i10;
import '../modules/user/controller/auth_controller.dart' as _i15;
import '../modules/user/controller/user_controller.dart' as _i21;
import '../modules/user/data/user_repository.dart' as _i11;
import '../modules/user/data/user_repository_impl.dart' as _i12;
import '../modules/user/service/user_service.dart' as _i13;
import '../modules/user/service/user_service_impl.dart' as _i14;
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
    gh.lazySingleton<_i6.SupplierRepository>(() => _i7.SupplierRepositoryImpl(
          connection: gh<_i3.DatabaseConnection>(),
          log: gh<_i8.Logger>(),
        ));
    gh.lazySingleton<_i9.SupplierService>(() => _i10.SupplierServiceImpl(
        supplierRepository: gh<_i6.SupplierRepository>()));
    gh.lazySingleton<_i11.UserRepository>(() => _i12.UserRepositoryImpl(
          connection: gh<_i3.DatabaseConnection>(),
          log: gh<_i8.Logger>(),
        ));
    gh.lazySingleton<_i13.UserService>(() => _i14.UserServiceImpl(
          userRepository: gh<_i11.UserRepository>(),
          log: gh<_i8.Logger>(),
        ));
    gh.factory<_i15.AuthController>(() => _i15.AuthController(
          userService: gh<_i13.UserService>(),
          log: gh<_i8.Logger>(),
        ));
    gh.lazySingleton<_i16.CategoriesRepository>(
        () => _i17.CategoriesRepositoryImpl(
              connection: gh<_i3.DatabaseConnection>(),
              log: gh<_i8.Logger>(),
            ));
    gh.lazySingleton<_i18.CategoriesService>(() => _i19.CategoriesServiceImpl(
        categoriesRepository: gh<_i16.CategoriesRepository>()));
    gh.factory<_i20.SupplierController>(() => _i20.SupplierController(
          supplierService: gh<_i9.SupplierService>(),
          log: gh<_i8.Logger>(),
        ));
    gh.factory<_i21.UserController>(() => _i21.UserController(
          userService: gh<_i13.UserService>(),
          log: gh<_i8.Logger>(),
        ));
    gh.factory<_i22.CategoriesController>(() => _i22.CategoriesController(
          categoriesService: gh<_i18.CategoriesService>(),
          log: gh<_i8.Logger>(),
        ));
    return this;
  }
}

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

import '../database/database_connection.dart' as _i4;
import '../database/database_connection_impl.dart' as _i5;
import '../modules/user/controller/auth_controller.dart' as _i3;
import 'database_connection_configuration.dart' as _i6;

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
    gh.factory<_i3.AuthController>(() => _i3.AuthController());
    gh.lazySingleton<_i4.DatabaseConnection>(() =>
        _i5.DatabaseConnectionImpl(gh<_i6.DatabaseConnectionConfiguration>()));
    return this;
  }
}

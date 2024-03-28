// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:my_profile/src/config/locator/app_module.dart' as _i7;
import 'package:my_profile/src/config/router/app_router.dart' as _i4;
import 'package:my_profile/src/domain/repository/local/hive_data_service_repo.dart'
    as _i5;
import 'package:my_profile/src/presentation/blocs/details/details_bloc.dart'
    as _i3;
import 'package:my_profile/src/presentation/blocs/login/login_bloc.dart' as _i6;

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
    final appModule = _$AppModule();
    gh.factory<_i3.DetailsBloc>(() => _i3.DetailsBloc());
    gh.singleton<_i4.AppRouter>(() => appModule.appRouter);
    gh.singleton<_i5.HiveDataServiceRepository>(
        () => appModule.hiveDataService);
    gh.singleton<_i6.LoginBloc>(() => _i6.LoginBloc());
    return this;
  }
}

class _$AppModule extends _i7.AppModule {}

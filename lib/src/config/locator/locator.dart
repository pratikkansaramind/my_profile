import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:my_profile/src/config/locator/locator.config.dart';
import 'package:my_profile/src/config/router/app_router.dart';
import 'package:my_profile/src/domain/repository/local/hive_data_service_repo.dart';
import 'package:my_profile/src/presentation/blocs/details/details_bloc.dart';
import 'package:my_profile/src/presentation/blocs/login/login_bloc.dart';

final locator = GetIt.instance;

/// App Routes
final appRouter = locator<AppRouter>();

/// App Local Storage
final hiveDataServiceRepo = locator<HiveDataServiceRepository>();

/// App Blocs
final loginBloc = locator<LoginBloc>();
final detailsBloc = locator<DetailsBloc>();

@InjectableInit(initializerName: 'init')
Future<void> configureDependencies() async => locator.init();
import 'package:injectable/injectable.dart';
import 'package:my_profile/src/config/router/app_router.dart';
import 'package:my_profile/src/data/datasources/local/hive_data_service.dart';
import 'package:my_profile/src/data/repository/local/hive_data_repo_impl.dart';
import 'package:my_profile/src/domain/models/skill_model.dart';
import 'package:my_profile/src/domain/models/user_details_model.dart';
import 'package:my_profile/src/domain/repository/local/hive_data_repo.dart';
import 'package:my_profile/src/domain/repository/local/hive_data_service_repo.dart';
import 'package:my_profile/src/utils/app_enum.dart';

@module
abstract class AppModule {
  @singleton
  AppRouter get appRouter => AppRouter();

  @singleton
  HiveDataServiceRepository get hiveDataService {
    HiveDataRepository<UserDetailsModel> hiveDataRepository =
        HiveDataRepositoryImpl(
      boxKey: BoxKey.userData.name,
    );

    HiveDataRepository<SkillModel> hiveSkillDataRepository =
        HiveDataRepositoryImpl(
      boxKey: BoxKey.skills.name,
    );

    HiveDataServiceRepository hiveDataService = HiveDataService(
      hiveDataRepository: hiveDataRepository,
      hiveSkillDataRepository: hiveSkillDataRepository,
    );

    return hiveDataService;
  }
}

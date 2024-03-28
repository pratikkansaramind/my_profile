import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_profile/src/config/locator/locator.dart';
import 'package:my_profile/src/domain/models/skill_model.dart';
import 'package:my_profile/src/domain/models/work_exp_model.dart';
import 'package:my_profile/src/presentation/views/edit_name_view.dart';
import 'package:my_profile/src/presentation/views/edit_skill_view.dart';
import 'package:my_profile/src/presentation/views/edit_work_exp_view.dart';
import 'package:my_profile/src/presentation/views/login_view.dart';
import 'package:my_profile/src/presentation/views/user_details_view.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LoginRoute.page,
          initial: hiveDataServiceRepo.isUserLoggedIn() == false,
        ),
        AutoRoute(
          page: UserDetailsRoute.page,
          initial: hiveDataServiceRepo.isUserLoggedIn(),
        ),
        AutoRoute(
          page: EditNameRoute.page,
        ),
        AutoRoute(
          page: EditSkillRoute.page,
        ),
        AutoRoute(
          page: EditWorkExpRoute.page,
        ),
      ];
}

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    EditNameRoute.name: (routeData) {
      final args = routeData.argsAs<EditNameRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditNamePage(
          key: args.key,
          name: args.name,
        ),
      );
    },
    EditSkillRoute.name: (routeData) {
      final args = routeData.argsAs<EditSkillRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditSkillPage(
          key: args.key,
          skills: args.skills,
        ),
      );
    },
    EditWorkExpRoute.name: (routeData) {
      final args = routeData.argsAs<EditWorkExpRouteArgs>(
          orElse: () => const EditWorkExpRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditWorkExpPage(
          key: args.key,
          workExpModel: args.workExpModel,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    UserDetailsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UserDetailsPage(),
      );
    },
  };
}

/// generated route for
/// [EditNamePage]
class EditNameRoute extends PageRouteInfo<EditNameRouteArgs> {
  EditNameRoute({
    Key? key,
    required String name,
    List<PageRouteInfo>? children,
  }) : super(
          EditNameRoute.name,
          args: EditNameRouteArgs(
            key: key,
            name: name,
          ),
          initialChildren: children,
        );

  static const String name = 'EditNameRoute';

  static const PageInfo<EditNameRouteArgs> page =
      PageInfo<EditNameRouteArgs>(name);
}

class EditNameRouteArgs {
  const EditNameRouteArgs({
    this.key,
    required this.name,
  });

  final Key? key;

  final String name;

  @override
  String toString() {
    return 'EditNameRouteArgs{key: $key, name: $name}';
  }
}

/// generated route for
/// [EditSkillPage]
class EditSkillRoute extends PageRouteInfo<EditSkillRouteArgs> {
  EditSkillRoute({
    Key? key,
    required List<SkillModel> skills,
    List<PageRouteInfo>? children,
  }) : super(
          EditSkillRoute.name,
          args: EditSkillRouteArgs(
            key: key,
            skills: skills,
          ),
          initialChildren: children,
        );

  static const String name = 'EditSkillRoute';

  static const PageInfo<EditSkillRouteArgs> page =
      PageInfo<EditSkillRouteArgs>(name);
}

class EditSkillRouteArgs {
  const EditSkillRouteArgs({
    this.key,
    required this.skills,
  });

  final Key? key;

  final List<SkillModel> skills;

  @override
  String toString() {
    return 'EditSkillRouteArgs{key: $key, skills: $skills}';
  }
}

/// generated route for
/// [EditWorkExpPage]
class EditWorkExpRoute extends PageRouteInfo<EditWorkExpRouteArgs> {
  EditWorkExpRoute({
    Key? key,
    WorkExpModel? workExpModel,
    List<PageRouteInfo>? children,
  }) : super(
          EditWorkExpRoute.name,
          args: EditWorkExpRouteArgs(
            key: key,
            workExpModel: workExpModel,
          ),
          initialChildren: children,
        );

  static const String name = 'EditWorkExpRoute';

  static const PageInfo<EditWorkExpRouteArgs> page =
      PageInfo<EditWorkExpRouteArgs>(name);
}

class EditWorkExpRouteArgs {
  const EditWorkExpRouteArgs({
    this.key,
    this.workExpModel,
  });

  final Key? key;

  final WorkExpModel? workExpModel;

  @override
  String toString() {
    return 'EditWorkExpRouteArgs{key: $key, workExpModel: $workExpModel}';
  }
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserDetailsPage]
class UserDetailsRoute extends PageRouteInfo<void> {
  const UserDetailsRoute({List<PageRouteInfo>? children})
      : super(
          UserDetailsRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserDetailsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

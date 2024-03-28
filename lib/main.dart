import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_profile/src/config/locator/locator.dart';
import 'package:my_profile/src/config/themes/app_theme.dart';

Future<void> main() async {
  await configureDependencies();
  await hiveDataServiceRepo.initHiveStorage();

  runApp(const MyProfileApp());
}

class MyProfileApp extends StatefulWidget {
  const MyProfileApp({super.key});

  @override
  State<MyProfileApp> createState() => _MyProfileAppState();
}

class _MyProfileAppState extends State<MyProfileApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => loginBloc,
        ),
        BlocProvider(
          create: (context) => detailsBloc,
        ),
      ],
      child: MaterialApp.router(
        title: 'My Profile',
        debugShowCheckedModeBanner: false,
        routerDelegate: appRouter.delegate(),
        routeInformationParser: appRouter.defaultRouteParser(),
        theme: AppTheme.light,
      ),
    );
  }

  @override
  void deactivate() {
    hiveDataServiceRepo.closeBox();
    super.deactivate();
  }
}

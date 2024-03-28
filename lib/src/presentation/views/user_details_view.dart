import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_profile/src/config/locator/locator.dart';
import 'package:my_profile/src/config/router/app_router.dart';
import 'package:my_profile/src/presentation/blocs/details/details_bloc.dart';
import 'package:my_profile/src/presentation/blocs/details/details_event.dart';
import 'package:my_profile/src/presentation/blocs/details/details_state.dart';
import 'package:my_profile/src/presentation/views/work_exp_row_view.dart';
import 'package:my_profile/src/presentation/widgets/user_image.dart';
import 'package:my_profile/src/utils/constants/app_assets.dart';
import 'package:my_profile/src/utils/extensions/screen_size_extensions.dart';

@RoutePage()
class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  @override
  Widget build(BuildContext context) {
    detailsBloc.add(ChangeUserEvent(
        userDetailsModel: hiveDataServiceRepo.fetchLoggedInUser()));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              detailsBloc.add(LogoutEvent());
            },
            icon: const Icon(
              Icons.power_settings_new_rounded,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.pixelScale(context)),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.pixelScale(context)),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        BlocBuilder<DetailsBloc, DetailsState>(
                          buildWhen: (previous, current) {
                            return current is UpdateImageState;
                          },
                          builder: (context, state) {
                            return UserImage(
                              userDetailsModel:
                                  hiveDataServiceRepo.fetchLoggedInUser(),
                            );
                          },
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () async {
                              detailsBloc.add(CheckMediaPermissionEvent());
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(2.pixelScale(context)),
                              child: SvgPicture.asset(
                                AppAssets.icEdit,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.pixelScale(context),
                    ),
                    Text(
                      hiveDataServiceRepo.fetchLoggedInUser().email,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              BlocConsumer<DetailsBloc, DetailsState>(
                listener: (context, state) {
                  if (state is LogoutState) {
                    AutoRouter.of(context).pushAndPopUntil(const LoginRoute(),
                        predicate: (route) => false);
                  }
                },
                buildWhen: (previous, current) {
                  return current is! LogoutState;
                },
                builder: (context, state) {
                  final userDetailsModel = state.userDetailsModel;
                  return Column(
                    children: [
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(16.pixelScale(context)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                    if (userDetailsModel.name.isNotEmpty)
                                      Text(
                                        userDetailsModel.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  AutoRouter.of(context).push(EditNameRoute(
                                    name: userDetailsModel.name,
                                  ));
                                },
                                child: SvgPicture.asset(
                                  AppAssets.icEdit,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.pixelScale(context)),
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(16.pixelScale(context)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'My Skills',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                      if (userDetailsModel.skills.isNotEmpty)
                                        Container(
                                          padding: EdgeInsets.only(
                                            top: 8.pixelScale(context),
                                          ),
                                          child: Wrap(
                                            alignment:
                                                WrapAlignment.spaceBetween,
                                            children: [
                                              ...userDetailsModel.skills
                                                  .map((e) {
                                                return Container(
                                                  padding: EdgeInsets.only(
                                                    right:
                                                        8.pixelScale(context),
                                                  ),
                                                  child: RawChip(
                                                    label: Text(e.name),
                                                  ),
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    AutoRouter.of(context).push(EditSkillRoute(
                                      skills: userDetailsModel.skills,
                                    ));
                                  },
                                  child: SvgPicture.asset(
                                    AppAssets.icEdit,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(16.pixelScale(context)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Work Experience',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      AutoRouter.of(context)
                                          .push(EditWorkExpRoute());
                                    },
                                    child: SvgPicture.asset(
                                      AppAssets.icAdd,
                                    ),
                                  ),
                                ],
                              ),
                              if (userDetailsModel.workExp.isNotEmpty)
                                SizedBox(
                                  height: 12.pixelScale(context),
                                ),
                              ...userDetailsModel.workExp.map(
                                (model) {
                                  return Column(
                                    children: [
                                      WorkExpRowView(
                                        model: model,
                                      ),
                                      if (userDetailsModel.workExp
                                              .indexOf(model) !=
                                          userDetailsModel.workExp.length - 1)
                                        Container(
                                          height: 1,
                                          margin: EdgeInsets.symmetric(
                                            vertical: 10.pixelScale(context),
                                          ),
                                          color: Colors.grey.withOpacity(0.3),
                                        )
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

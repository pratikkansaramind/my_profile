import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_profile/src/config/locator/locator.dart';
import 'package:my_profile/src/domain/models/skill_model.dart';
import 'package:my_profile/src/presentation/blocs/details/details_bloc.dart';
import 'package:my_profile/src/presentation/blocs/details/details_event.dart';
import 'package:my_profile/src/presentation/blocs/details/details_state.dart';
import 'package:my_profile/src/utils/constants/app_assets.dart';
import 'package:my_profile/src/utils/extensions/screen_size_extensions.dart';

@RoutePage()
class EditSkillPage extends StatelessWidget {
  final List<SkillModel> skills;

  const EditSkillPage({
    super.key,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    detailsBloc.add(UserSkillEvent(list: skills));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Skills',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: BlocConsumer<DetailsBloc, DetailsState>(
        listener: (context, state) {
          if (state is UpdateSkillState) {
            AutoRouter.of(context).maybePop();
          }
        },
        buildWhen: (previous, current) {
          return current is UserSkillState;
        },
        builder: (context, state) {
          final userSkills = <SkillModel>[];

          if (state is UserSkillState) {
            userSkills.addAll(state.list);
          }

          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.pixelScale(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.pixelScale(context)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Skills',
                          textAlign: TextAlign.start,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        if (userSkills.isEmpty)
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              vertical: 24.pixelScale(context),
                            ),
                            child: const Text(
                              'You have not added any skills.',
                            ),
                          ),
                        if (userSkills.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 16.pixelScale(context),
                            ),
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                ...userSkills.map((e) {
                                  return Container(
                                    padding: EdgeInsets.only(
                                      right: 8.pixelScale(context),
                                    ),
                                    child: RawChip(
                                      label: Text(e.name),
                                      deleteIcon: SvgPicture.asset(
                                        AppAssets.icDelete,
                                      ),
                                      onDeleted: () {
                                        userSkills.remove(e);
                                        detailsBloc.add(
                                            UserSkillEvent(list: userSkills));
                                      },
                                      onPressed: () {
                                        userSkills.remove(e);
                                        detailsBloc.add(
                                            UserSkillEvent(list: userSkills));
                                      },
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              detailsBloc
                                  .add(UpdateSkillEvent(list: userSkills));
                            },
                            child: Text(
                              'Save',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.pixelScale(context),
                ),
                Text(
                  'Skills:',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      ...hiveDataServiceRepo
                          .getAllSkills(userSkills: userSkills)
                          .map((e) {
                        return Container(
                          padding: EdgeInsets.only(
                            right: 8.pixelScale(context),
                          ),
                          child: RawChip(
                            label: Text(e.name),
                            deleteIcon: const Icon(Icons.add_rounded),
                            onDeleted: () {
                              userSkills.add(e);
                              detailsBloc.add(UserSkillEvent(list: userSkills));
                            },
                            onPressed: () {
                              userSkills.add(e);
                              detailsBloc.add(UserSkillEvent(list: userSkills));
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

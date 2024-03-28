import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_profile/src/config/locator/locator.dart';
import 'package:my_profile/src/config/router/app_router.dart';
import 'package:my_profile/src/domain/models/work_exp_model.dart';
import 'package:my_profile/src/presentation/blocs/details/details_event.dart';
import 'package:my_profile/src/utils/constants/app_assets.dart';
import 'package:my_profile/src/utils/extensions/screen_size_extensions.dart';

class WorkExpRowView extends StatelessWidget {
  final WorkExpModel model;

  const WorkExpRowView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                model.jobTitle,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            GestureDetector(
              onTap: () {
                AutoRouter.of(context).push(EditWorkExpRoute(
                  workExpModel: model,
                ));
              },
              child: SvgPicture.asset(
                AppAssets.icEdit,
              ),
            ),
            SizedBox(
              width: 8.pixelScale(context),
            ),
            GestureDetector(
              onTap: () {
                detailsBloc.add(DeleteWorkExpEvent(model: model));
              },
              child: SvgPicture.asset(
                AppAssets.icDelete,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.pixelScale(context),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Company Name',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  Text(
                    model.companyName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Years of Experience',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  Text(
                    '${model.years} - Years',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

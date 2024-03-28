import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_profile/src/domain/models/user_details_model.dart';
import 'package:my_profile/src/utils/extensions/screen_size_extensions.dart';

class RememberMePage extends StatelessWidget {
  final List<UserDetailsModel> users;

  const RememberMePage({
    super.key,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.pixelScale(context)),
      child: Column(
        children: [
          Icon(
            Icons.key_rounded,
            size: 32.pixelScale(context),
          ),
          ...users.map((user) {
            return InkWell(
              onTap: () {
                AutoRouter.of(context).maybePop(user);
              },
              child: Card(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.pixelScale(context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.email,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const Text(
                        '********',
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_profile/src/config/locator/locator.dart';
import 'package:my_profile/src/domain/models/user_details_model.dart';
import 'package:my_profile/src/utils/extensions/screen_size_extensions.dart';

class UserImage extends StatelessWidget {
  final UserDetailsModel userDetailsModel;

  const UserImage({super.key, required this.userDetailsModel});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      child: Container(
        width: 100.pixelScale(context),
        height: 100.pixelScale(context),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: (userDetailsModel.image).isNotEmpty
            ? Image.memory(
                base64Decode(userDetailsModel.image),
                fit: BoxFit.cover,
              )
            : Padding(
                padding: EdgeInsets.all(10.pixelScale(context)),
                child: Icon(
                  Icons.person,
                  size: 48.pixelScale(context),
                ),
              ),
      ),
    );
  }
}

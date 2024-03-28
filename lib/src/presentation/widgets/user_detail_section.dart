import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_profile/src/utils/constants/app_assets.dart';
import 'package:my_profile/src/utils/extensions/screen_size_extensions.dart';

class UserDetailSection extends StatelessWidget {
  final Animation<double> animation;
  final EdgeInsets margin;
  final String label;
  final String msg;
  final String extraMsg;
  final Function moveToPrevious;

  const UserDetailSection({
    super.key,
    required this.animation,
    required this.margin,
    required this.label,
    required this.msg,
    this.extraMsg = '',
    required this.moveToPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Visibility(
        visible: animation.value != 0,
        child: Container(
          margin: margin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello,',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Container(
                height: 20.pixelScale(context),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  moveToPrevious();
                },
                icon: SvgPicture.asset(
                  AppAssets.icEdit,
                  color: Colors.white,
                ),
                label: Text(
                  label.trim(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                height: 20.pixelScale(context),
              ),
              extraMsg.trim().isEmpty
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          extraMsg,
                          textAlign: TextAlign.start,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: const Color(0xFF44C1FF),
                                  ),
                        ),
                        Container(
                          height: 20.pixelScale(context),
                        ),
                      ],
                    ),
              Text(
                msg,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

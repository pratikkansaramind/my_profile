

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_profile/src/utils/extensions/screen_size_extensions.dart';

class LabelSection extends StatelessWidget {
  final Animation<double> animation;
  final String label1;
  final String label2;

  const LabelSection({
    super.key,
    required this.animation,
    required this.label1,
    required this.label2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label1,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 30.pixelScale(context),
                fontWeight: FontWeight.bold,
                color: animation.isCompleted
                    ? Colors.black.withOpacity(0.4)
                    : Colors.black,
              ),
        ),
        SizedBox(
          height: 10.pixelScale(context),
        ),
        Text(
          label2,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }
}

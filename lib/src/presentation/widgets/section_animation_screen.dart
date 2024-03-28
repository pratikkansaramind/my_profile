

import 'package:flutter/material.dart';
import 'package:my_profile/src/utils/extensions/screen_size_extensions.dart';

class SectionAnimationScreen extends StatelessWidget {
  final Animation<double> section1SlideUpAnimation;
  final Animation<double> section1FadeAnimation;
  final Animation<double> section2FadeAnimation;
  final Widget section1;
  final Widget section2;

  const SectionAnimationScreen({
    super.key,
    required this.section1SlideUpAnimation,
    required this.section1FadeAnimation,
    required this.section2FadeAnimation,
    required this.section1,
    required this.section2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FadeTransition(
          opacity: section1FadeAnimation,
          child: Transform.translate(
            offset: Offset(0, section1SlideUpAnimation.value),
            child: Visibility(
              visible: section1FadeAnimation.value != 0,
              child: section1,
            ),
          ),
        ),
        Container(
          height: 20.pixelScale(context),
        ),
        FadeTransition(
          opacity: section2FadeAnimation,
          child: SingleChildScrollView(
            child: Visibility(
              visible: section2FadeAnimation.value != 0,
              child: section2,
            ),
          ),
        ),
      ],
    );
  }
}

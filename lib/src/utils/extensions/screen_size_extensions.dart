import 'package:flutter/material.dart';

final _sizeCache = <num, Map<num, double>>{};

extension ScreenDimension on num {
  double ws(BuildContext context) {
    /// calculate device width, we will make it key
    final deviceWidth = MediaQuery.sizeOf(context).width;

    /// If the current [deviceWidth] key and the [this] is present
    /// in already computed list the return result
    if (_sizeCache.containsKey(deviceWidth) &&
        _sizeCache[deviceWidth]!.containsKey(this)) {
      return _sizeCache[deviceWidth]![this] as double;
    }

    /// check if device width is present
    /// if not present create an entry
    if (!_sizeCache.containsKey(deviceWidth)) {
      _sizeCache.addAll({deviceWidth: {}});
    }

    final value = deviceWidth * (this / 100);
    _sizeCache[deviceWidth]!.addAll({this: value});

    return value;
  }

  double pixelScale(BuildContext context) => ((this + 2) / 4).ws(context);

  double removeSpacingOnKeyboardVisible(BuildContext context) {
    if (MediaQuery.maybeViewInsetsOf(context)!.bottom > 0) {
      return this * 0;
    }

    return this * 1;
  }

  double addSpacingOnKeyboardVisible(BuildContext context) =>
      this + MediaQuery.maybeViewInsetsOf(context)!.bottom;

  double hs(BuildContext context) =>
      MediaQuery.sizeOf(context).height * (this / 100);
}
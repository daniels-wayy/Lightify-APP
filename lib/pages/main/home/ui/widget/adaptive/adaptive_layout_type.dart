import 'package:flutter/material.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';

enum AdaptiveLayoutType {
  regular,
  tablet,
  desktop,
}

extension AdaptiveLayoutTypeX on AdaptiveLayoutType {
  static const regularCrossAxisCount = 2;
  static const tabletCrossAxisCount = 3;
  static const desktopCrossAxisCount = 4;

  int get itemsCrossAxisCount {
    switch (this) {
      case AdaptiveLayoutType.regular:
        return regularCrossAxisCount;
      case AdaptiveLayoutType.tablet:
        return tabletCrossAxisCount;
      case AdaptiveLayoutType.desktop:
        return 2;
    }
  }

  int get brightnessIconSize {
    switch (this) {
      case AdaptiveLayoutType.regular:
        return 26;
      case AdaptiveLayoutType.tablet:
      case AdaptiveLayoutType.desktop:
        return 18;
    }
  }

  double? get brightnessTextSize {
    switch (this) {
      case AdaptiveLayoutType.regular:
        return null;
      case AdaptiveLayoutType.tablet:
      case AdaptiveLayoutType.desktop:
        return 20;
    }
  }

  int get detailsButtonSize {
    switch (this) {
      case AdaptiveLayoutType.regular:
        return 26;
      case AdaptiveLayoutType.tablet:
      case AdaptiveLayoutType.desktop:
        return 20;
    }
  }

  EdgeInsetsGeometry get padding {
    switch (this) {
      case AdaptiveLayoutType.regular:
        return EdgeInsets.symmetric(horizontal: width(12), vertical: height(12));
      case AdaptiveLayoutType.tablet:
      case AdaptiveLayoutType.desktop:
        return EdgeInsets.symmetric(horizontal: width(8), vertical: height(10)).copyWith(
          bottom: height(14),
        );
    }
  }

  double? get deviceNameTextSize {
    switch (this) {
      case AdaptiveLayoutType.regular:
        return null;
      case AdaptiveLayoutType.tablet:
      case AdaptiveLayoutType.desktop:
        return 23;
    }
  }
}

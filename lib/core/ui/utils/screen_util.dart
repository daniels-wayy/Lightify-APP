import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class ScreenUtil {
  // static const int defaultWidth = 1080;
  // static const int defaultHeight = 1920;
  // static const double defaultPixelRatio = 2.625;

  // static late double _pixelRatio;
  // static late double _aspectRatio;

  // static double get pixelRatio => _pixelRatio;
  // static double get aspectRatio => _aspectRatio;

  static late double _screenWidthPx;
  static late double _screenWidthLp;

  static double get screenWidthPx => _screenWidthPx;
  static double get screenWidthLp => _screenWidthLp;

  static late double _screenHeightPx;
  static late double _screenHeightLp;

  static double get screenHeightPx => _screenHeightPx;
  static double get screenHeightLp => _screenHeightLp;

  static late double _topPadding;
  static late double _bottomPadding;

  static double get topPadding => _topPadding;
  static double get bottomPadding => _bottomPadding;

  static final WidgetsBinding _widgetsBinding = WidgetsBinding.instance;

  static void init(BoxConstraints constraints) {
    _screenWidthLp = constraints.maxWidth;
    _screenHeightLp = constraints.maxHeight;
    // _pixelRatio = _widgetsBinding.window.devicePixelRatio;
    _screenWidthPx = _widgetsBinding.window.physicalSize.width;
    _screenHeightPx = _widgetsBinding.window.physicalSize.height;
    // _aspectRatio = _widgetsBinding.window.physicalSize.aspectRatio;

    // debugPrint(
    //     'ScreenUtil: ${scaleDimension}| ${_screenWidthLp.toStringAsFixed(2)}/${_screenHeightLp.toStringAsFixed(2)}: $_pixelRatio($_screenWidthPx/$_screenHeightPx)${_aspectRatio.toStringAsFixed(2)}');
  }

  static void initPaddings(EdgeInsets padding) {
    _topPadding = padding.top;
    _bottomPadding = padding.bottom;
  }

  /// The ratio of the actual dp to the design draft px
  // static double get scaleWidth => _screenWidthLp / defaultWidth;

  // static double get scaleHeight => _screenHeightLp / defaultHeight;

  // double get scaleText => scaleWidth * (defaultPixelRatio / pixelRatio);
  // static double get scaleDimension => (defaultPixelRatio / pixelRatio);
}

// int heightPx(double dpHeight) => height(dpHeight.floor()).floor();
// int widthPx(double dpWidth) => width(dpWidth.floor()).floor();

// double height(int dpHeight) => dpHeight * (ScreenUtil.defaultPixelRatio / ScreenUtil.pixelRatio);
// double width(int dpWidth) => dpWidth * (ScreenUtil.defaultPixelRatio / ScreenUtil.pixelRatio);

double height(int dpHeight) => dpHeight * defHeight;
double width(int dpWidth) => dpWidth * defWidth;

final defHeight = ScreenUtil.screenHeightLp / 812;
final defWidth = ScreenUtil._screenWidthLp / 375;

// double height(int dpHeight) => dpHeight.toDouble() * ScreenUtil.scaleHeight;
// double width(int dpWidth) => dpWidth.toDouble() * ScreenUtil.scaleWidth;

// double heightFraction(double fraction) => ScreenUtil.screenHeightLp * (fraction / 100);

// double widthFraction(double fraction) => ScreenUtil._screenWidthLp * (fraction / 100);

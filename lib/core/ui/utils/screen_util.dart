import 'package:flutter/material.dart';

class ScreenUtil {
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

    _screenWidthPx = _widgetsBinding.window.physicalSize.width;
    _screenHeightPx = _widgetsBinding.window.physicalSize.height;
  }

  static void initPaddings(EdgeInsets padding) {
    _topPadding = padding.top;
    _bottomPadding = padding.bottom;
  }
}

double height(int dpHeight) => dpHeight * defHeight;
double width(int dpWidth) => dpWidth * defWidth;

final defHeight = ScreenUtil.screenHeightLp / 812;
final defWidth = ScreenUtil._screenWidthLp / 375;

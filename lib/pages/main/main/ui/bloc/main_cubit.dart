// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'main_state.dart';

enum TabIndex {
  HOME(0),
  SETTINGS(1);

  final int value;
  const TabIndex(this.value);
}

extension TabIndexExtension on TabIndex {
  String getName() {
    switch (this) {
      case TabIndex.HOME:
        return 'Home';
      case TabIndex.SETTINGS:
        return 'Settings';
    }
  }

  IconData icon(BuildContext context) {
    switch (this) {
      case TabIndex.HOME:
        return PlatformIcons(context).home;
      case TabIndex.SETTINGS:
        return PlatformIcons(context).settings;
    }
  }

  double iconSize() {
    switch (this) {
      case TabIndex.HOME:
        return height(Platform.isIOS ? 22 : 24);
      case TabIndex.SETTINGS:
        return height(24);
    }
  }
}

@injectable
class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainState.initialState());

  static late BuildContext context;

  static final navigatorKeys = {
    TabIndex.HOME: GlobalKey<NavigatorState>(),
    TabIndex.SETTINGS: GlobalKey<NavigatorState>(),
  };

  void changeTab(TabIndex tabIndex) {
    if (state.tabIndex != tabIndex) {
      emit(state.copyWith(tabIndex: tabIndex));
    }
  }
}

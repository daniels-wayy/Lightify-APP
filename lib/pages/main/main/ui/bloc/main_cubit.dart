// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
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

  IconData getUnselectedIcon() {
    switch (this) {
      case TabIndex.HOME:
        return Icons.home_outlined;
      case TabIndex.SETTINGS:
        return Icons.settings_outlined;
    }
  }

  IconData getSelectedIcon() {
    switch (this) {
      case TabIndex.HOME:
        return Icons.home;
      case TabIndex.SETTINGS:
        return Icons.settings;
    }
  }
}

@injectable
class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainState.initialState());

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

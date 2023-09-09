import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/data/model/color_preset.dart';
import 'package:lightify/core/data/storages/common_storage.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/utils/dialog_util.dart';

import 'user_pref_state.dart';

@LazySingleton()
class UserPrefCubit extends Cubit<UserPrefState> {
  final CommonStorage commonStorage;

  UserPrefCubit({required this.commonStorage})
      : super(UserPrefState.initialState(
          commonStorage,
        ));

  Future<void> addColorPreset(ColorPreset preset) async {
    final currentPresets = [...state.colorPresets];
    if (currentPresets.any((element) => element.color == preset.color)) {
      DialogUtil.showToast(AppConstants.strings.PRESET_ALREADY_EXIST);
    } else {
      currentPresets.add(preset);
      await commonStorage.storeColorPresets(currentPresets);
      emit(state.copyWith(colorPresets: currentPresets));
    }
  }

  Future<void> removeColorPreset(ColorPreset preset) async {
    final currentPresets = [...state.colorPresets];
    currentPresets.removeWhere((element) => element == preset);
    await commonStorage.storeColorPresets(currentPresets);
    emit(state.copyWith(colorPresets: currentPresets));
  }

  Future<void> onShowNavigationBarChanged(bool value) async {
    emit(state.copyWith(showNavigationBar: value));
    await commonStorage.storeNavigationBarSetting(value);
  }

  Future<void> onShowHomeSelectorBarChanged(bool value) async {
    emit(state.copyWith(showHomeSelectorBar: value));
    await commonStorage.storeHomeSelectorBarSetting(value);
  }
}

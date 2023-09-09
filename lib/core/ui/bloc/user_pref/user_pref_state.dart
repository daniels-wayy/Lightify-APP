import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lightify/core/data/model/color_preset.dart';
import 'package:lightify/core/data/storages/common_storage.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';

part 'user_pref_state.freezed.dart';

@freezed
class UserPrefState with _$UserPrefState {
  const UserPrefState._();
  const factory UserPrefState({
    required List<ColorPreset> colorPresets,
    required bool showNavigationBar,
    required bool showHomeSelectorBar,
  }) = _UserPrefState;

  factory UserPrefState.initialState(CommonStorage commonStorage) => UserPrefState(
        colorPresets: [...commonStorage.getColorPresets()],
        showNavigationBar: commonStorage.getNavigationBarSetting(),
        showHomeSelectorBar: commonStorage.getHomeSelectorBarSetting(),
      );

  List<ColorPreset> get getDisplayColorPresets => [
        ...AppConstants.settings.defaultColorPresets,
        ...colorPresets,
      ];
}

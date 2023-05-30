import 'package:freezed_annotation/freezed_annotation.dart';
import 'main_cubit.dart';

part 'main_state.freezed.dart';

@freezed
class MainState with _$MainState {
  const factory MainState({
    required TabIndex tabIndex,
  }) = _MainState;

  factory MainState.initialState() => const MainState(
        tabIndex: TabIndex.HOME,
      );
}

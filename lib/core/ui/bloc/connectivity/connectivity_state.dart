import 'package:freezed_annotation/freezed_annotation.dart';

part 'connectivity_state.freezed.dart';

@freezed
class ConnectivityState with _$ConnectivityState {
  const ConnectivityState._();
  const factory ConnectivityState({
    required bool connectedToNet,
    required bool connectionEstablished,
  }) = _ConnectivityState;

  factory ConnectivityState.initialState() => const ConnectivityState(
        connectedToNet: true,
        connectionEstablished: false,
      );
}

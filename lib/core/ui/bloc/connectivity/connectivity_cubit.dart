import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/domain/repo/connectivity_repo.dart';

import 'connectivity_state.dart';

@LazySingleton()
class ConnectivityCubit extends Cubit<ConnectivityState> {
  final ConnectivityRepo _connectivityRepo;

  StreamSubscription<bool>? _connectivitySubscription;
  Timer? _connectionEstablishmentTimer;

  ConnectivityCubit(this._connectivityRepo) : super(ConnectivityState.initialState()) {
    _connectivitySubscription = _connectivityRepo.connectedToNet().listen((connected) {
      _connectionToNetChanged(connected);
    });
  }

  void _connectionToNetChanged(bool connectedToNet) {
    debugPrint('ConnectivityCubit connectionToNetChanged / isConnected: $connectedToNet');
    emit(state.copyWith(connectedToNet: connectedToNet));
    establishConnection();
  }

  void establishConnection() {
    if (!state.connectionEstablished) {
      _connectionEstablishmentTimer?.cancel();
      _connectionEstablishmentTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (timer.tick >= 1) {
          timer.cancel();
          emit(state.copyWith(connectionEstablished: true));
        }
      });
    }
  }

  @override
  Future<void> close() async {
    _connectivitySubscription?.cancel();
    _connectionEstablishmentTimer?.cancel();
    super.close();
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/domain/repo/connectivity_repo.dart';

import 'connectivity_state.dart';

@Singleton()
class ConnectivityCubit extends Cubit<ConnectivityState> {
  final ConnectivityRepo _connectivityRepo;

  StreamSubscription<bool>? _connectivitySubscription;

  ConnectivityCubit(this._connectivityRepo) : super(ConnectivityState.initialState()) {
    _connectivitySubscription = _connectivityRepo.connectedToNet().listen((connected) {
      _connectionToNetChanged(connected);
    });
  }

  void _connectionToNetChanged(bool connectedToNet) {
    debugPrint('ConnectivityCubit connectionToNetChanged / isConnected: $connectedToNet');
    if (state.connectedToNet != connectedToNet) {
      emit(state.copyWith(connectedToNet: connectedToNet));
    }
  }

  @override
  Future<void> close() async {
    _connectivitySubscription?.cancel();
    super.close();
  }
}

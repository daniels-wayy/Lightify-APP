import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/workflow.dart';
import 'package:lightify/core/data/model/workflow_response.dart';
import 'package:lightify/core/domain/repo/device_repo.dart';
import 'package:lightify/core/domain/repo/network_repo.dart';
import 'package:lightify/core/ui/bloc/connectivity/connectivity_cubit.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';

part 'device_workflows_state.dart';
part 'device_workflows_cubit.freezed.dart';

@Injectable()
class DeviceWorkflowsCubit extends Cubit<DeviceWorkflowsState> {
  final DeviceRepo _deviceRepo;
  final ConnectivityCubit _connectivityCubit;
  final NetworkRepo _networkRepo;

  DeviceWorkflowsCubit(
    @factoryParam this._currentDeviceTopic,
    this._deviceRepo,
    this._connectivityCubit,
    this._networkRepo,
  ) : super(DeviceWorkflowsState.initial());

  late final String _currentDeviceTopic;

  Timer? _loadingTimer;
  Timer? _sendTimer;

  void _ensureConnected(Function func) {
    if (_connectivityCubit.state.connectedToNet && _networkRepo.isConnectedToServer()) {
      func();
    }
  }

  @override
  Future<void> close() {
    _loadingTimer?.cancel();
    _sendTimer?.cancel();
    return super.close();
  }

  void getCurrentWorkflows(String topic) {
    emit(state.copyWith(isLoading: true));
    _loadingTimer = Timer(
      const Duration(seconds: 2),
      () {
        debugPrint('getCurrentWorkflows loading timed out');
        emit(state.copyWith(isLoading: false));
      },
    );
    _deviceRepo.getDeviceWorkflowsInfoFor(topic);
  }

  Future<void> onReceivedData(String topic, WorkflowResponse workflow) async {
    if (topic == workflow.topic) {
      _loadingTimer?.cancel();
      final filtered = workflow.items.unique((x) => x.id);
      final sorted = filtered..sort((a, b) => a.minutesRemaining.compareTo(b.minutesRemaining));
      emit(state.copyWith(
        workflows: sorted,
        isLoading: false,
      ));
    }
  }

  void deleteWorkflows(List<Device> devices) {
    _send(devices, _deviceRepo.deleteDeviceWorkflows);
    emit(state.copyWith(workflows: []));
  }

  void addWorkflow(List<Device> devices, Workflow workflow) {
    _send(devices, (device) => _deviceRepo.addDeviceWorkflow(device, workflow));
  }

  void updateWorkflow(List<Device> devices, Workflow workflow) {
    _send(devices, (device) => _deviceRepo.updateDeviceWorkflow(device, workflow));
  }

  void deleteWorkflow(List<Device> devices, Workflow workflow) {
    _send(devices, (device) => _deviceRepo.deleteDeviceWorkflow(device, workflow));
  }

  void _send(List<Device> devices, Function(Device) sendDataFunction) {
    _ensureConnected(() {
      _sendTimer?.cancel();
      _sendTimer = Timer(AppConstants.api.MQTT_SEND_REQUEST_THRESHOLD, () async {
        try {
          for (final device in devices) {
            sendDataFunction(device);
            await Future<void>.delayed(AppConstants.api.MQTT_SEND_REQUEST_THRESHOLD);
            if (device.deviceInfo.topic == _currentDeviceTopic) {
              _deviceRepo.getDeviceWorkflowsInfoFor(_currentDeviceTopic);
            }
          }
        } catch (e) {
          debugPrint('DeviceWorkflowsCubit _send error occured: $e');
        }
      });
    });
  }

  void resetState() {
    emit(DeviceWorkflowsState.initial());
  }
}

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/workflow.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/utils/function_util.dart';

part 'workflow_form_state.dart';
part 'workflow_form_cubit.freezed.dart';

@injectable
class WorkflowFormCubit extends Cubit<WorkflowFormState> {
  WorkflowFormCubit({
    @factoryParam this.workflow,
    @factoryParam required this.currentDevice,
  }) : super(WorkflowFormState.initial(
          workflow: workflow,
          currentDevice: currentDevice,
        ));

  final Workflow? workflow;
  late final Device currentDevice;

  static const defaultRepeat = 1;
  static const defaultDuration = 1;
  static const defaultBrightness = 0;
  static const brightnessScaleDivisions = 5; // 100% / 5
  static const brightnessGradientColors = [Colors.red, Colors.orange, Colors.yellow, Colors.green];
  static final brightnessGradientSequence = TweenSequence([
    for (var i = 0; i < brightnessGradientColors.length; i++)
      if (brightnessGradientColors.containsAt(i + 1))
        TweenSequenceItem(
          tween: ColorTween(
            begin: brightnessGradientColors[i],
            end: brightnessGradientColors[i + 1],
          ),
          weight: 1.0,
        ),
  ]);

  void onTimeChanged(DateTime time) {
    emit(state.copyWith(
      hour: time.hour,
      minute: time.minute,
    ));
  }

  void onRepeatChanged(int value) {
    emit(state.copyWith(day: value));
  }

  void onDurationChanged(int value) {
    emit(state.copyWith(duration: value));
  }

  void onBrightnessChanged(int value) {
    emit(state.copyWith(brightness: value * WorkflowFormCubit.brightnessScaleDivisions));
  }

  void onApplyDeviceFor(Device device) {
    if (currentDevice.deviceInfo.topic == device.deviceInfo.topic) { // if current
      return;
    }
    final currentSelection = [...state.selectedDevices];
    if (currentSelection.any((e) => e.deviceInfo.topic == device.deviceInfo.topic)) {
      currentSelection.removeWhere((e) => e.deviceInfo.topic == device.deviceInfo.topic);
    } else {
      currentSelection.add(device);
    }
    emit(state.copyWith(selectedDevices: currentSelection));
  }
}

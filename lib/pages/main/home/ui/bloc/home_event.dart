import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lightify/core/data/model/device.dart';

part 'home_event.freezed.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.initConnection() = _InitConnection;

  const factory HomeEvent.onMQTTConnected() = _OnMQTTConnected;
  const factory HomeEvent.onMQTTDisconnected() = _OnMQTTDisconnected;

  const factory HomeEvent.onPowerChanged(Device device, bool state) = _OnPowerChanged;
  const factory HomeEvent.onBrightnessChanged(Device device, int state) = _OnBrightnessChanged;
  const factory HomeEvent.onColorChanged(Device device, HSVColor state) = _OnColorChanged;
  const factory HomeEvent.onBreathChanged(Device device, double state) = _OnBreathChanged;
  const factory HomeEvent.onDeviceGroupSleepMode(List<Device> devices) = _OnDeviceGroupSleepMode;
  const factory HomeEvent.onDeviceGroupTurnOff(List<Device> devices) = _OnDeviceGroupTurnOff;

  const factory HomeEvent.onRefresh() = _OnRefresh;
  const factory HomeEvent.onReceivedMessage(String? data) = _OnReceivedMessage;
}

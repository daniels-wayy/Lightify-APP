part of 'devices_updater_bloc.dart';

@freezed
abstract class DevicesUpdaterEvent with _$DevicesUpdaterEvent {
  const factory DevicesUpdaterEvent.changePower(Device device, bool state) = _ChangePower;
  const factory DevicesUpdaterEvent.changeBrightness(Device device, int state) = _ChangeBrightness;
  const factory DevicesUpdaterEvent.changeColor(Device device, HSVColor state) = _ChangeColor;
  const factory DevicesUpdaterEvent.changeBreath(Device device, double state) = _ChangeBreath;
  const factory DevicesUpdaterEvent.changeEffect(Device device, int state) = _ChangeEffect;
  const factory DevicesUpdaterEvent.changeEffectSpeed(Device device, int state) = _ChangeEffectSpeed;
  const factory DevicesUpdaterEvent.changeEffectScale(Device device, int state) = _ChangeEffectScale;
  const factory DevicesUpdaterEvent.sleepDeviceGroup(List<Device> devices) = _SleepDeviceGroup;
  const factory DevicesUpdaterEvent.turnOffDeviceGroup(List<Device> devices) = _TurnOffDeviceGroup;

  const factory DevicesUpdaterEvent.disconnect() = _Disconnect;
  const factory DevicesUpdaterEvent.resume() = _Resume;
}
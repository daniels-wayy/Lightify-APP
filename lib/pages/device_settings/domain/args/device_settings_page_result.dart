import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_settings_page_result.freezed.dart';

@freezed
abstract class DeviceSettingsPageResult with _$DeviceSettingsPageResult {
  const DeviceSettingsPageResult._();
  const factory DeviceSettingsPageResult.factoryReset() = _FactoryReset;

  bool get isFactoryReset {
    return maybeWhen(
      factoryReset: () => true,
      orElse: () => false,
    );
  }
}

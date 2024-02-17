import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lightify/core/data/model/device.dart';

part 'home_widget_device_entity.g.dart';

@JsonSerializable(includeIfNull: false)
class HomeWidgetDeviceEntity {
  final bool currentPowerState;
  final double currentBrightness;
  final String deviceTopic;
  final int colorHex;
  final String? iconPath;

  const HomeWidgetDeviceEntity({
    required this.currentPowerState,
    required this.currentBrightness,
    required this.deviceTopic,
    required this.colorHex,
    this.iconPath,
  });

  factory HomeWidgetDeviceEntity.fromJson(Map<String, dynamic> json) => _$HomeWidgetDeviceEntityFromJson(json);

  Map<String, dynamic> toJson() => _$HomeWidgetDeviceEntityToJson(this);

  @override
  String toString() {
    return 'HomeWidgetDeviceEntity($deviceTopic, $colorHex)';
  }

  factory HomeWidgetDeviceEntity.fromDevice(Device device) {
    return HomeWidgetDeviceEntity(
      currentPowerState: device.powered,
      currentBrightness: device.brightnessFactor,
      deviceTopic: device.deviceInfo.topic,
      colorHex: device.getColor.value,
    );
  }

  HomeWidgetDeviceEntity copyWith({
    final bool? currentPowerState,
    final String? iconPath,
  }) => HomeWidgetDeviceEntity(
        currentPowerState: currentPowerState ?? this.currentPowerState,
        currentBrightness: currentBrightness,
        deviceTopic: deviceTopic,
        colorHex: colorHex,
        iconPath: iconPath ?? this.iconPath,
      );

  Color get color {
    return currentPowerState ? Color(colorHex) : Colors.grey.withOpacity(0.85);
  }

  int get brightnessPercent {
    return (currentBrightness * 100).toInt();
  }

  IconData get icon {
    switch (deviceTopic) {
      case 'DSLY_Livingroom_TV':
        return Icons.tv;
      case 'DSLY_Kitchen_Workspace':
        return Icons.restaurant;
      case 'DSLY_Bedroom_Bed':
        return Icons.bed_outlined;
      case 'DSLY_Bedroom_Monitor':
        return Icons.monitor;
      case 'DSLY_Livingroom_Piano':
        return Icons.piano;
      case 'DSLY_Bedroom_Bed_Upperside':
        return Icons.bedroom_parent_outlined;
      case 'DSLY_Office_Desk':
        return Icons.desk;
      default:
        return Icons.light;
    }
  }
}

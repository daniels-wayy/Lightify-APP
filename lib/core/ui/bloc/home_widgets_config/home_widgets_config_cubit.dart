import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/config.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/domain/repo/current_device_repo.dart';
import 'package:lightify/core/ui/bloc/home_widgets_config/data/models/home_widgets_dto.dart';
import 'package:lightify/core/ui/bloc/home_widgets_config/utils/home_widgets_functions.dart';
import 'package:lightify/pages/main/settings/home_widgets/data/models/home_widget_device_entity.dart';

part 'home_widgets_config_state.dart';
part 'home_widgets_config_cubit.freezed.dart';
part 'home_widgets_config_cubit.g.dart';

@LazySingleton()
class HomeWidgetsConfigCubit extends Cubit<HomeWidgetsConfigState> with HydratedMixin {
  final CurrentDeviceRepo _currentDeviceRepo;

  HomeWidgetsConfigCubit(this._currentDeviceRepo) : super(HomeWidgetsConfigState.initial()) {
    _checkIfWidgetsAvailable();
  }

  static const minIOSForWidgets = 17.0;
  static const smallWidgetDevicesCount = 4;
  static const mediumWidgetDevicesCount = 4;
  static const bigWidgetDevicesCount = 12;

  static const widgetsUpdateThreshold = Duration(milliseconds: 500);
  static const widgetsUpdateFromDeviceThreshold = Duration(milliseconds: 300);

  Timer? _widgetsUpdateTimer;
  Timer? _widgetsUpdateFromDeviceTimer;

  @override
  Future<void> close() {
    _widgetsUpdateTimer?.cancel();
    _widgetsUpdateFromDeviceTimer?.cancel();
    return super.close();
  }

  Future<void> _ensureAvailable(Function function, {bool isInit = false}) async {
    if (state.isWidgetsAvailable && (isInit || state.isNotEmpty)) {
      await function();
    }
  }

  Future<bool> _checkIfWidgetsAvailable() async {
    final iosVersion = await _currentDeviceRepo.getIOSVersion();
    final isAvailable = iosVersion != null && iosVersion >= minIOSForWidgets;
    debugPrint(
        'HomeWidgetsConfigCubit _checkIfWidgetsAvailable() - iosVersion: $iosVersion, isAvailable: $isAvailable');
    emit(state.copyWith(isWidgetsAvailable: isAvailable));
    return isAvailable;
  }

  Future<void> setWidgetsFromDevices(List<Device> devices) async {
    var isWidgetsAvailable = state.isWidgetsAvailable;

    if (!isWidgetsAvailable) {
      isWidgetsAvailable = await _checkIfWidgetsAvailable();
    }
 
    if (!isWidgetsAvailable || state.isNotEmpty) {
      if (state.isNotEmpty) {
        updateAllWidgets(devices);
      }
      return;
    }

    final primaryHouseRemotes = Config.primaryHouse.remotes;
    final sortedDevices = List<Device>.from(devices);
    sortedDevices.sort((a, b) =>
        primaryHouseRemotes.indexOf(a.deviceInfo.topic).compareTo(primaryHouseRemotes.indexOf(b.deviceInfo.topic)));
    final widgetDeviceEntities = sortedDevices.map((device) => HomeWidgetDeviceEntity.fromDevice(device));
    final generatedWidgets = await _generateWidgetsIcons(widgetDeviceEntities);
    emit(state.copyWith(
      smallWidget: generatedWidgets.take(smallWidgetDevicesCount).toList(),
      mediumWidget: generatedWidgets.take(mediumWidgetDevicesCount).toList(),
      bigWidget: generatedWidgets.take(bigWidgetDevicesCount).toList(),
    ));
    _updateWidgets(isInit: true);
  }

  Future<void> updateAllWidgets(List<Device> devices) async {
    _widgetsUpdateFromDeviceTimer?.cancel();
    _widgetsUpdateFromDeviceTimer = Timer(widgetsUpdateFromDeviceThreshold, () {
      _ensureAvailable(() async {
        final currentWidgetsState = await HomeWidgetsFunctions.getWidgetState();

        Iterable<HomeWidgetDeviceEntity> smallWidget = currentWidgetsState?.smallWidget ?? state.smallWidget;
        Iterable<HomeWidgetDeviceEntity> mediumWidget = currentWidgetsState?.mediumWidget ?? state.mediumWidget;
        Iterable<HomeWidgetDeviceEntity> bigWidget = currentWidgetsState?.bigWidget ?? state.bigWidget;

        for (final device in devices) {
          smallWidget = smallWidget
              .map((e) => (device.deviceInfo.topic == e.deviceTopic) ? HomeWidgetDeviceEntity.fromDevice(device) : e);

          mediumWidget = mediumWidget
              .map((e) => (device.deviceInfo.topic == e.deviceTopic) ? HomeWidgetDeviceEntity.fromDevice(device) : e);

          bigWidget = bigWidget
              .map((e) => (device.deviceInfo.topic == e.deviceTopic) ? HomeWidgetDeviceEntity.fromDevice(device) : e);
        }

        final generatedSmallWidget = await _generateWidgetsIcons(smallWidget);
        final generatedMediumWidget = await _generateWidgetsIcons(mediumWidget);
        final generatedBigWidget = await _generateWidgetsIcons(bigWidget);

        emit(state.copyWith(
          smallWidget: generatedSmallWidget.take(smallWidgetDevicesCount).toList(),
          mediumWidget: generatedMediumWidget.take(mediumWidgetDevicesCount).toList(),
          bigWidget: generatedBigWidget.take(bigWidgetDevicesCount).toList(),
        ));

        _updateWidgets();
      });
    });
  }

  Future<void> updateWidgetsWithDevice(Device device) async {
    _widgetsUpdateFromDeviceTimer?.cancel();
    _widgetsUpdateFromDeviceTimer = Timer(widgetsUpdateFromDeviceThreshold, () {
      _ensureAvailable(() async {
        final currentWidgetsState = await HomeWidgetsFunctions.getWidgetState();

        final smallWidget = (currentWidgetsState?.smallWidget ?? state.smallWidget)
            .map((e) => (device.deviceInfo.topic == e.deviceTopic) ? HomeWidgetDeviceEntity.fromDevice(device) : e);

        final mediumWidget = (currentWidgetsState?.mediumWidget ?? state.mediumWidget)
            .map((e) => (device.deviceInfo.topic == e.deviceTopic) ? HomeWidgetDeviceEntity.fromDevice(device) : e);

        final bigWidget = (currentWidgetsState?.bigWidget ?? state.bigWidget)
            .map((e) => (device.deviceInfo.topic == e.deviceTopic) ? HomeWidgetDeviceEntity.fromDevice(device) : e);

        final generatedSmallWidget = await _generateWidgetsIcons(smallWidget);
        final generatedMediumWidget = await _generateWidgetsIcons(mediumWidget);
        final generatedBigWidget = await _generateWidgetsIcons(bigWidget);

        emit(state.copyWith(
          smallWidget: generatedSmallWidget.take(smallWidgetDevicesCount).toList(),
          mediumWidget: generatedMediumWidget.take(mediumWidgetDevicesCount).toList(),
          bigWidget: generatedBigWidget.take(bigWidgetDevicesCount).toList(),
        ));

        _updateWidgets();
      });
    });
  }

  Future<void> smallDevicesSelectionChanged(HomeWidgetDeviceEntity device) async {
    final newDevices = [...state.smallWidget];

    if (state.smallWidget.any((e) => e.deviceTopic == device.deviceTopic)) {
      if (newDevices.length <= 1) {
        return;
      }
      newDevices.removeWhere((e) => e.deviceTopic == device.deviceTopic);
    } else {
      if (state.smallWidget.length == smallWidgetDevicesCount) {
        newDevices.removeLast();
        newDevices.add(device);
      } else {
        newDevices.add(device);
      }
    }

    final generatedEntities = await _generateWidgetsIcons(newDevices);
    emit(state.copyWith(smallWidget: generatedEntities));
    _updateWidgets();
  }

  Future<void> mediumDevicesSelectionChanged(HomeWidgetDeviceEntity device) async {
    final newDevices = [...state.mediumWidget];

    if (state.mediumWidget.any((e) => e.deviceTopic == device.deviceTopic)) {
      if (newDevices.length <= 1) {
        return;
      }
      newDevices.removeWhere((e) => e.deviceTopic == device.deviceTopic);
    } else {
      if (state.mediumWidget.length == mediumWidgetDevicesCount) {
        newDevices.removeLast();
        newDevices.add(device);
      } else {
        newDevices.add(device);
      }
    }

    final generatedEntities = await _generateWidgetsIcons(newDevices);
    emit(state.copyWith(mediumWidget: generatedEntities));
    _updateWidgets();
  }

  Future<void> bigDevicesSelectionChanged(HomeWidgetDeviceEntity device) async {
    final newDevices = [...state.bigWidget];

    if (state.bigWidget.any((e) => e.deviceTopic == device.deviceTopic)) {
      if (newDevices.length <= 1) {
        return;
      }
      newDevices.removeWhere((e) => e.deviceTopic == device.deviceTopic);
    } else {
      if (state.bigWidget.length == bigWidgetDevicesCount) {
        newDevices.removeLast();
        newDevices.add(device);
      } else {
        newDevices.add(device);
      }
    }

    final generatedEntities = await _generateWidgetsIcons(newDevices);
    emit(state.copyWith(bigWidget: generatedEntities));
    _updateWidgets();
  }

  void _updateWidgets({bool isInit = false}) {
    _ensureAvailable(() {
      _widgetsUpdateTimer?.cancel();
      _widgetsUpdateTimer = Timer(widgetsUpdateThreshold, () {
        HomeWidgetsFunctions.updateWidgets(state.widgetsDTO);
      });
    }, isInit: isInit);
  }

  Future<List<HomeWidgetDeviceEntity>> _generateWidgetsIcons(Iterable<HomeWidgetDeviceEntity> entities) async {
    final globalKey = GlobalKey();
    final result = <HomeWidgetDeviceEntity>[];

    for (final entity in entities) {
      final icon = Icon(key: globalKey, entity.icon, size: 26.0, color: Colors.white.withOpacity(0.85));
      final iconPath = await HomeWidget.renderFlutterWidget(
        icon,
        key: '${entity.deviceTopic}_icon',
        pixelRatio: 1.0,
        logicalSize: const Size(256, 256),
      );
      result.add(entity.copyWith(iconPath: iconPath));
    }

    return result;
  }

  @override
  HomeWidgetsConfigState? fromJson(Map<String, dynamic> json) {
    return HomeWidgetsConfigState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(HomeWidgetsConfigState state) {
    return state.toJson();
  }
}

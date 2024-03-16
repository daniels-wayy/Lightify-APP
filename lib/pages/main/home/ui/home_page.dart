import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lightify/config.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/house.dart';
import 'package:lightify/core/ui/bloc/connectivity/connectivity_cubit.dart';
import 'package:lightify/core/ui/bloc/connectivity/connectivity_state.dart';
import 'package:lightify/core/ui/bloc/devices/devices_cubit.dart';
import 'package:lightify/core/ui/bloc/home_widgets_config/home_widgets_config_cubit.dart';
import 'package:lightify/core/ui/bloc/user_pref/user_pref_cubit.dart';
import 'package:lightify/core/ui/bloc/user_pref/user_pref_state.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/dialog_util.dart';
import 'package:lightify/core/ui/utils/reorder_util.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/widget/common/bouncing_widget.dart';
import 'package:lightify/core/ui/widget/common/error_widget.dart';
import 'package:lightify/core/ui/widget/common/fading_edge_widget.dart';
import 'package:lightify/core/ui/widget/progress/loading_widget.dart';
import 'package:lightify/pages/main/home/ui/devices_updater/devices_updater_bloc.dart';
import 'package:lightify/pages/main/home/ui/devices_watcher/devices_watcher_bloc.dart';
import 'package:lightify/pages/main/home/ui/widget/adaptive/adaptive_home_body.dart';
import 'package:lightify/pages/main/home/ui/widget/home_fab_widget.dart';
import 'package:lightify/pages/main/home/ui/widget/home_tab_bar.dart';
import 'package:lightify/pages/main/main/ui/bloc/main_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final TabController controller;
  var house = Config.primaryHouse;
  var prevTabIndex = -1;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    controller = TabController(length: Config.houses.length, vsync: this)..addListener(_tabListener);
    WidgetsBinding.instance.addObserver(this);
    _initializeConnection();
  }

  void _initializeConnection({bool connect = true}) {
    // // check for registration
    // if (!getIt.isRegistered<HomeBloc>()) {
    //   getIt.registerFactory<HomeBloc>(() => HomeBloc(
    //         deviceRepo: getIt<DeviceRepo>(),
    //         networkRepo: getIt<NetworkRepo>(),
    //         devicesCubit: getIt<DevicesCubit>(),
    //         connectivityCubit: getIt<ConnectivityCubit>(),
    //       ));
    // }
    // context.read<HomeBloc>().add(HomeEvent.initConnection(house, connect: connect));

    if (connect) {
      context.read<DevicesWatcherBloc>().add(DevicesWatcherEvent.initialize(house));
    } else {
      context.read<DevicesWatcherBloc>().add(DevicesWatcherEvent.overrideConnectivityCallbacks(house));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<DevicesWatcherBloc>().add(const DevicesWatcherEvent.checkConnectionState());
      });
    }
  }

  void _tabListener() {
    if (prevTabIndex != controller.index) {
      prevTabIndex = controller.index;
      house = Config.houses[controller.index];
      _initializeConnection(connect: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DevicesWatcherBloc, DevicesWatcherState>(
      listener: (_, state) => context.read<DevicesCubit>().setDevices(state.availableDevices),
      listenWhen: (p, c) => p.devices.length != c.devices.length,
      child: BlocListener<DevicesUpdaterBloc, DevicesUpdaterState>(
          listener: (_, __) => context.read<DevicesWatcherBloc>().add(const DevicesWatcherEvent.disconnect()),
          listenWhen: (p, c) => !p.isDisconnected && c.isDisconnected,
          child: BlocBuilder<UserPrefCubit, UserPrefState>(builder: (context, userPrefState) {
            return Scaffold(
              backgroundColor: AppColors.fullBlack,
              body: BlocListener<ConnectivityCubit, ConnectivityState>(
                listener: (_, __) {},
                listenWhen: (oldState, newState) {
                  if (!newState.connectionEstablished) {
                    return false;
                  }
                  if (oldState.connectedToNet && !newState.connectedToNet) {
                    // Connection lost
                    DialogUtil.showNoConnectionSnackbar(context);
                  } else if (!oldState.connectedToNet && newState.connectedToNet) {
                    // Connection restored
                    DialogUtil.closeSnackBar(context);
                    _initializeConnection();
                  }
                  return false;
                },
                child: BlocBuilder< /*HomeBloc*/ DevicesWatcherBloc, /*HomeState*/ DevicesWatcherState>(
                    builder: (_, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedCrossFade(
                        sizeCurve: Curves.ease,
                        crossFadeState:
                            userPrefState.showHomeSelectorBar ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 250),
                        secondChild: Container(),
                        firstChild: Column(
                          children: [
                            SizedBox(height: height(14)),
                            SafeArea(
                              bottom: false,
                              child: Row(
                                children: [
                                  SizedBox(width: width(6)),
                                  HomeTabBar(context: context, controller: controller),
                                  const Spacer(),
                                  !userPrefState.showNavigationBar
                                      ? Padding(
                                          padding: EdgeInsets.only(left: width(12), right: width(18)),
                                          child: BouncingWidget(
                                            onTap: () =>
                                                MainCubit.context.read<MainCubit>().changeTab(TabIndex.SETTINGS),
                                            child: Icon(
                                              PlatformIcons(context).settings,
                                              size: height(Platform.isIOS ? 21 : 23),
                                              color: Colors.white54,
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 800),
                            child: state.maybeWhen(
                              loading: _buildConnectingState,
                              loaded: _buildConnectedState,
                              disconnected: _buildDisconnectedState,
                              orElse: () => const SizedBox.shrink(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              floatingActionButton:
                  !userPrefState.showNavigationBar && !userPrefState.showHomeSelectorBar ? const HomeFAB() : null,
            );
          })),
    );
  }

  Widget _buildConnectingState() {
    return const Center(child: LoadingWidget());
  }

  Widget _buildDisconnectedState() {
    return CustomErrorWidget(error: 'MQTT Disconnected', onRetry: _initializeConnection);
  }

  Widget _buildConnectedState(List<Device> devices) {
    return BlocBuilder<UserPrefCubit, UserPrefState>(builder: (context, userPrefState) {
      return TabBarView(
        physics: !userPrefState.showHomeSelectorBar ? const NeverScrollableScrollPhysics() : null,
        controller: controller,
        children: Config.houses
            .map(
              (house) => _buildDevicesGrid(house, devices),
            )
            .toList(),
      );
    });
  }

  Widget _buildDevicesGrid(House house, List<Device> devices) {
    final houseDevices = devices
        .where((device) => house.remotes.any(
              (remote) => device.deviceInfo.topic == remote,
            ))
        .toList();

    if (houseDevices.isEmpty) {
      return const SizedBox.shrink();
    }

    final groupedDevices = /*houseDevices.groupBy((p0) => p0.deviceInfo.deviceGroup)*/
        ReorderUtil.getDevicesPerOrder(houseDevices);

    return FadingEdge(
      scrollDirection: Axis.vertical,
      child: AdaptiveHomeBody(
        groupedDevices: groupedDevices,
        onDevicePowerChanged: _onPowerStateChanged,
        onDeviceBrightnessChanged: _onBrightnessStateChanged,
        onDeviceColorChanged: _onColorStateChanged,
        onDeviceBreathChanged: _onBreathStateChanged,
        onDeviceEffectChanged: _onEffectStateChanged,
        onDeviceEffectSpeedChanged: _onEffectSpeedStateChanged,
        onDeviceEffectScaleChanged: _onEffectScaleStateChanged,
        onDeviceGroupSleepMode: _onDeviceGroupSleepMode,
        onDeviceGroupTurnOff: _onDeviceGroupTurnOff,
        onRefresh: _onRefresh,
        onReorder: _onReorder,
      ),
    );
  }

  void _onReorder(Map<String, List<Device>> currentState, int oldI, int newI) {
    final groupNames = [...currentState.keys.toList()];
    final oldName = groupNames.removeAt(oldI);
    groupNames.insert(newI, oldName);
    ReorderUtil.updateDevicesGroupOrder(groupNames);
    setState(() {});
  }

  Future<void> _onRefresh() async {
    // context.read<HomeBloc>().add(HomeEvent.onRefresh(house));
    context.read<DevicesWatcherBloc>().add(DevicesWatcherEvent.refresh(house));
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  void _onPowerStateChanged(Device device, bool state) {
    // context.read<HomeBloc>().add(HomeEvent.onPowerChanged(device, state));
    context.read<DevicesUpdaterBloc>().add(DevicesUpdaterEvent.changePower(device, state));
    context.read<HomeWidgetsConfigCubit>().updateWidgetsWithDevice(device.copyWith(powered: state));
  }

  void _onBrightnessStateChanged(Device device, int state) {
    // context.read<HomeBloc>().add(HomeEvent.onBrightnessChanged(device, state));
    context.read<DevicesUpdaterBloc>().add(DevicesUpdaterEvent.changeBrightness(device, state));
    context.read<HomeWidgetsConfigCubit>().updateWidgetsWithDevice(device.copyWith(brightness: state));
  }

  void _onColorStateChanged(Device device, HSVColor state) {
    // context.read<HomeBloc>().add(HomeEvent.onColorChanged(device, state));
    context.read<DevicesUpdaterBloc>().add(DevicesUpdaterEvent.changeColor(device, state));
    context.read<HomeWidgetsConfigCubit>().updateWidgetsWithDevice(device.copyWith(color: state));
  }

  void _onBreathStateChanged(Device device, double state) {
    // context.read<HomeBloc>().add(HomeEvent.onBreathChanged(device, state));
    context.read<DevicesUpdaterBloc>().add(DevicesUpdaterEvent.changeBreath(device, state));
  }

  void _onEffectStateChanged(Device device, int state) {
    // context.read<HomeBloc>().add(HomeEvent.onEffectChanged(device, state));
    context.read<DevicesUpdaterBloc>().add(DevicesUpdaterEvent.changeEffect(device, state));
  }

  void _onEffectSpeedStateChanged(Device device, double state) {
    // context.read<HomeBloc>().add(HomeEvent.onEffectSpeedChanged(device, state));
    context.read<DevicesUpdaterBloc>().add(DevicesUpdaterEvent.changeEffectSpeed(device, state.toInt()));
  }

  void _onEffectScaleStateChanged(Device device, double state) {
    // context.read<HomeBloc>().add(HomeEvent.onEffectScaleChanged(device, state));
    context.read<DevicesUpdaterBloc>().add(DevicesUpdaterEvent.changeEffectScale(device, state.toInt()));
  }

  void _onDeviceGroupSleepMode(List<Device> devices) {
    // context.read<HomeBloc>().add(HomeEvent.onDeviceGroupSleepMode(devices));
    context.read<DevicesUpdaterBloc>().add(DevicesUpdaterEvent.sleepDeviceGroup(devices));
  }

  void _onDeviceGroupTurnOff(List<Device> devices) {
    // context.read<HomeBloc>().add(HomeEvent.onDeviceGroupTurnOff(devices));
    context.read<DevicesUpdaterBloc>().add(DevicesUpdaterEvent.turnOffDeviceGroup(devices));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/ui/bloc/connectivity/connectivity_cubit.dart';
import 'package:lightify/core/ui/bloc/connectivity/connectivity_state.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/dialog_util.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/widget/common/error_widget.dart';
import 'package:lightify/core/ui/widget/progress/loading_widget.dart';
import 'package:lightify/pages/main/home/ui/bloc/home_cubit.dart';
import 'package:lightify/pages/main/home/ui/bloc/home_state.dart';
import 'package:lightify/pages/main/home/ui/widget/devices_group.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _initializeConnection();
  }

  void _initializeConnection() => context.read<HomeCubit>().init();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fullBlack,
      body: BlocListener<ConnectivityCubit, ConnectivityState>(
        listener: (_, __) {},
        listenWhen: (oldState, newState) {
          if ((oldState.connectedToNet && !newState.connectedToNet) ||
              (!oldState.connectedToNet && !newState.connectedToNet)) {
            // Connection lost
            DialogUtil.showNoConnectionSnackbar(context);
          } else if (!oldState.connectedToNet && newState.connectedToNet) {
            // Connection restored
            DialogUtil.closeSnackBar(context);
            _initializeConnection();
          }
          return false;
        },
        child: BlocBuilder<HomeCubit, HomeState>(builder: (_, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            child: state.connecting
                ? const Center(child: LoadingWidget())
                : state.error != null
                    ? Center(child: CustomErrorWidget(error: state.error!, onRetry: _initializeConnection))
                    : Builder(builder: (context) {
                        final devices = state.groupedDevices;
                        return CustomScrollView(
                          key: const PageStorageKey('devices'),
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          slivers: [
                            CupertinoSliverRefreshControl(
                              refreshIndicatorExtent: height(80),
                              refreshTriggerPullDistance: height(120),
                              builder: (context, refreshState, pulledExtent, refreshTriggerPullDistance,
                                  refreshIndicatorExtent) {
                                final animate = refreshState != RefreshIndicatorMode.drag;
                                return Padding(
                                  padding: EdgeInsets.only(top: height(64)),
                                  child: Center(
                                    child: LoadingWidget(
                                        rotationAnimationValue:
                                            animate ? null : pulledExtent / refreshTriggerPullDistance,
                                        animate: animate),
                                  ),
                                );
                              },
                              onRefresh: _onRefresh,
                            ),
                            SliverSafeArea(
                              sliver: SliverPadding(
                                padding: EdgeInsets.symmetric(horizontal: width(18), vertical: height(20)),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(childCount: devices.length, (_, index) {
                                    final groupName = devices.keys.toList()[index];
                                    final groupDevices = devices.values.toList()[index];
                                    return DevicesGroup(
                                      groupIndex: index,
                                      groupName: groupName,
                                      groupDevices: groupDevices,
                                      onDevicePowerChanged: _onPowerStateChanged,
                                      onDeviceBrightnessChanged: _onBrightnessStateChanged,
                                      onDeviceColorChanged: _onColorStateChanged,
                                      onDeviceBreathChanged: _onBreathStateChanged,
                                      onDeviceGroupSleepMode: _onDeviceGroupSleepMode,
                                      onDeviceGroupTurnOff: _onDeviceGroupTurnOff,
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
          );
        }),
      ),
    );
  }

  Future<void> _onRefresh() => context.read<HomeCubit>().onRefresh();

  void _onPowerStateChanged(Device device, bool state) {
    context.read<HomeCubit>().onPowerChanged(device, state);
  }

  void _onBrightnessStateChanged(Device device, int state) {
    context.read<HomeCubit>().onBrightnessChanged(device, state);
  }

  void _onColorStateChanged(Device device, HSVColor state) {
    context.read<HomeCubit>().onColorChanged(device, state);
  }

  void _onBreathStateChanged(Device device, double state) {
    context.read<HomeCubit>().onBreathChanged(device, state);
  }

  void _onDeviceGroupSleepMode(List<Device> devices) {
    context.read<HomeCubit>().onDeviceGroupSleepMode(devices);
  }

  void _onDeviceGroupTurnOff(List<Device> devices) {
    context.read<HomeCubit>().onDeviceGroupTurnOff(devices);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/domain/repo/device_repo.dart';
import 'package:lightify/core/domain/repo/network_repo.dart';
import 'package:lightify/core/ui/bloc/connectivity/connectivity_cubit.dart';
import 'package:lightify/core/ui/bloc/connectivity/connectivity_state.dart';
import 'package:lightify/core/ui/bloc/devices/devices_cubit.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/dialog_util.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/widget/common/error_widget.dart';
import 'package:lightify/core/ui/widget/progress/loading_widget.dart';
import 'package:lightify/di/di.dart';
import 'package:lightify/pages/main/home/ui/bloc/home_bloc.dart';
import 'package:lightify/pages/main/home/ui/bloc/home_event.dart';
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

  void _initializeConnection() {
    // check for registration
    if (!getIt.isRegistered<HomeBloc>()) {
      getIt.registerFactory<HomeBloc>(() => HomeBloc(
            deviceRepo: getIt<DeviceRepo>(),
            networkRepo: getIt<NetworkRepo>(),
            devicesCubit: getIt<DevicesCubit>(),
            connectivityCubit: getIt<ConnectivityCubit>(),
          ));
    }
    context.read<HomeBloc>().add(const HomeEvent.initConnection());
  }

  @override
  Widget build(BuildContext context) {
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
        child: BlocBuilder<HomeBloc, HomeState>(builder: (_, state) {
          return Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              child: state.maybeMap(
                connecting: (_) => _buildConnectingState(),
                connected: (state) => _buildConnectedState(state.groupedDevices),
                disconnected: (_) => _buildDisconnectedState(),
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildConnectingState() {
    return const Center(child: LoadingWidget());
  }

  Widget _buildDisconnectedState() {
    return CustomErrorWidget(error: 'MQTT Disconnected', onRetry: _initializeConnection);
  }

  Widget _buildConnectedState(Map<String, List<Device>>? devices) {
    if (devices == null || devices.isEmpty) {
      return const SizedBox.shrink();
    }
    return CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        CupertinoSliverRefreshControl(
          refreshIndicatorExtent: height(80),
          refreshTriggerPullDistance: height(120),
          builder: (context, refreshState, pulledExtent, refreshTriggerPullDistance, refreshIndicatorExtent) {
            final animate = refreshState != RefreshIndicatorMode.drag;
            return Padding(
              padding: EdgeInsets.only(top: height(64)),
              child: Center(
                child: LoadingWidget(
                    rotationAnimationValue: animate ? null : pulledExtent / refreshTriggerPullDistance,
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
  }

  Future<void> _onRefresh() async {
    context.read<HomeBloc>().add(const HomeEvent.onRefresh());
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  void _onPowerStateChanged(Device device, bool state) {
    context.read<HomeBloc>().add(HomeEvent.onPowerChanged(device, state));
  }

  void _onBrightnessStateChanged(Device device, int state) {
    context.read<HomeBloc>().add(HomeEvent.onBrightnessChanged(device, state));
  }

  void _onColorStateChanged(Device device, HSVColor state) {
    context.read<HomeBloc>().add(HomeEvent.onColorChanged(device, state));
  }

  void _onBreathStateChanged(Device device, double state) {
    context.read<HomeBloc>().add(HomeEvent.onBreathChanged(device, state));
  }

  void _onDeviceGroupSleepMode(List<Device> devices) {
    context.read<HomeBloc>().add(HomeEvent.onDeviceGroupSleepMode(devices));
  }

  void _onDeviceGroupTurnOff(List<Device> devices) {
    context.read<HomeBloc>().add(HomeEvent.onDeviceGroupTurnOff(devices));
  }
}

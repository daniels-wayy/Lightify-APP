import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/ui/bloc/user_pref/user_pref_cubit.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/utils/vibration_util.dart';
import 'package:lightify/core/ui/widget/progress/loading_widget.dart';
import 'package:lightify/pages/main/home/ui/widget/adaptive/adaptive_layout_type.dart';
import 'package:lightify/pages/main/home/ui/widget/devices_group.dart';
import 'package:reorderables/reorderables.dart';

class TabletHomeBody extends StatelessWidget {
  final Map<String, List<Device>> groupedDevices;
  final void Function(Device, bool) onDevicePowerChanged;
  final void Function(Device, int) onDeviceBrightnessChanged;
  final void Function(Device, HSVColor) onDeviceColorChanged;
  final void Function(Device, double) onDeviceBreathChanged;
  final void Function(Device, int) onDeviceEffectChanged;
  final void Function(Device, double) onDeviceEffectSpeedChanged;
  final void Function(Device, double) onDeviceEffectScaleChanged;
  final void Function(List<Device>) onDeviceGroupSleepMode;
  final void Function(List<Device>) onDeviceGroupTurnOff;
  final Future Function() onRefresh;
  final void Function(Map<String, List<Device>>, int, int) onReorder;

  const TabletHomeBody({
    super.key,
    required this.groupedDevices,
    required this.onDevicePowerChanged,
    required this.onDeviceBrightnessChanged,
    required this.onDeviceColorChanged,
    required this.onDeviceBreathChanged,
    required this.onDeviceEffectChanged,
    required this.onDeviceEffectSpeedChanged,
    required this.onDeviceEffectScaleChanged,
    required this.onDeviceGroupSleepMode,
    required this.onDeviceGroupTurnOff,
    required this.onRefresh,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: ScrollController(),
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
          onRefresh: onRefresh,
        ),
        SliverSafeArea(
          top: !context.read<UserPrefCubit>().state.showHomeSelectorBar,
          sliver: SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: width(16)).copyWith(
              top: height(24),
              bottom: height(74),
            ),
            sliver: ReorderableSliverList(
              onReorder: (oldI, newI) => onReorder(groupedDevices, oldI, newI),
              onReorderStarted: (_) => VibrationUtil.vibrate(),
              controller: ScrollController(),
              buildDraggableFeedback: (context, constraints, child) => ConstrainedBox(
                constraints: constraints,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        offset: const Offset(0.0, -10.0),
                        blurRadius: 15.0,
                      ),
                    ],
                  ),
                  child: child,
                ),
              ),
              delegate: ReorderableSliverChildBuilderDelegate(childCount: groupedDevices.length, (_, index) {
                final groupName = groupedDevices.keys.toList()[index];
                final groupDevices = groupedDevices.values.toList()[index];
                return DevicesGroup(
                  key: ObjectKey(groupName),
                  groupIndex: index,
                  groupName: groupName,
                  groupDevices: groupDevices,
                  onDevicePowerChanged: onDevicePowerChanged,
                  onDeviceBrightnessChanged: onDeviceBrightnessChanged,
                  onDeviceColorChanged: onDeviceColorChanged,
                  onDeviceBreathChanged: onDeviceBreathChanged,
                  onDeviceEffectChanged: onDeviceEffectChanged,
                  onDeviceEffectSpeedChanged: onDeviceEffectSpeedChanged,
                  onDeviceEffectScaleChanged: onDeviceEffectScaleChanged,
                  onDeviceGroupSleepMode: onDeviceGroupSleepMode,
                  onDeviceGroupTurnOff: onDeviceGroupTurnOff,
                  layoutType: AdaptiveLayoutType.tablet,
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/data/model/firmware_update_status.dart';
import 'package:lightify/core/ui/bloc/devices/devices_cubit.dart';
import 'package:lightify/core/ui/bloc/firmware_update/firmware_update_cubit.dart';
import 'package:lightify/core/ui/bloc/home_widgets_config/home_widgets_config_cubit.dart';
import 'package:lightify/core/ui/bloc/user_pref/user_pref_cubit.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/routes/settings_routes.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/widget/common/app_version_info_widget.dart';
import 'package:lightify/core/ui/widget/common/bouncing_widget.dart';
import 'package:lightify/core/ui/widget/common/custom_pop_scope.dart';
import 'package:lightify/core/ui/widget/common/fading_edge_widget.dart';
import 'package:lightify/core/ui/widget/common/title_switch_widget.dart';
import 'package:lightify/core/ui/widget/progress/loading_widget.dart';
import 'package:lightify/pages/main/home/ui/devices_watcher/devices_watcher_bloc.dart';
import 'package:lightify/pages/main/main/ui/bloc/main_cubit.dart';
import 'package:lightify/pages/main/settings/home_widgets/ui/widgets/home_widget_variants/home_widget_small_widget.dart';
import 'package:lightify/pages/main/settings/settings/ui/widgets/settings_app_bar_widget.dart';

part 'package:lightify/pages/main/settings/settings/ui/widgets/navigation_bar_switch_widget.dart';
part 'package:lightify/pages/main/settings/settings/ui/widgets/home_selector_bar_switch_widget.dart';
part 'package:lightify/pages/main/settings/settings/ui/widgets/app_info_widget.dart';
part 'package:lightify/pages/main/settings/settings/ui/widgets/home_widgets_pref_bar_widget.dart';
part 'package:lightify/pages/main/settings/settings/ui/widgets/firmware_version_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  bool _listener(BuildContext context, DevicesWatcherState p, DevicesWatcherState c) {
    if (!p.isLoaded && c.isLoaded) {
      Future.delayed(const Duration(seconds: 1), () {
        context.read<FirmwareUpdateCubit>().checkVersion();
        context.read<HomeWidgetsConfigCubit>().setWidgetsFromDevices(
              context.read<DevicesCubit>().state.availableDevices,
            );
      });
    }
    if (p.devices.length != c.devices.length) {
      context.read<DevicesCubit>().setDevices(c.availableDevices);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DevicesWatcherBloc, DevicesWatcherState>(
      listener: (_, __) {},
      listenWhen: (p, c) => _listener(context, p, c),
      child: CustomPopScope(
        onWillPop: () async {
          MainCubit.context.read<MainCubit>().changeTab(TabIndex.HOME);
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: AppColors.fullBlack,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height(26)),
              const SettingsAppBar(),
              SizedBox(height: height(14)),
              Expanded(
                child: FadingEdge(
                  scrollDirection: Axis.vertical,
                  child: RefreshIndicator.adaptive(
                    onRefresh: () {
                      return context.read<FirmwareUpdateCubit>().checkVersion();
                      // return Future<void>.delayed(const Duration(seconds: 1));
                    },
                    backgroundColor: Colors.white,
                    child: ListView(
                      physics: Platform.isIOS
                          ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())
                          : const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      padding: EdgeInsets.symmetric(horizontal: width(18), vertical: height(12)).copyWith(
                        bottom: ScreenUtil.bottomPadding + height(70),
                      ),
                      children: [
                        SizedBox(height: height(12)),
                        const _NavigationBarSwitch(),
                        SizedBox(height: height(20)),
                        const _HomeSelectorBarSwitch(),
                        BlocBuilder<HomeWidgetsConfigCubit, HomeWidgetsConfigState>(
                          builder: (context, widgetsState) {
                            if (!widgetsState.isWidgetsAvailable) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: EdgeInsets.only(top: height(32)),
                              child: _HomeWidgetsPrefBarWidget(onTap: () => _onHomeWidgetsTap(context)),
                            );
                          },
                        ),
                        SizedBox(height: height(28)),
                        const _AppInfo(),
                        SizedBox(height: height(40)),
                        const _FirmwareVersion(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onHomeWidgetsTap(BuildContext context) {
    Navigator.of(context).pushNamed(SettingsRoutes.HOME_WIDGETS_PAGE);
  }
}

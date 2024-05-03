import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightify/core/ui/bloc/user_pref/user_pref_cubit.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/utils/vibration_util.dart';
import 'package:lightify/core/ui/widget/common/bouncing_widget.dart';
import 'package:lightify/pages/main/main/ui/bloc/main_cubit.dart';
import 'package:lightify/core/ui/routes/home_routes.dart';
import 'package:lightify/core/ui/routes/settings_routes.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static final views = [
    Navigator(
      restorationScopeId: 'home',
      initialRoute: HomeRoutes.HOME,
      key: MainCubit.navigatorKeys[TabIndex.HOME],
      onGenerateRoute: homeRouteFactory,
    ),
    Navigator(
      restorationScopeId: 'settings',
      initialRoute: SettingsRoutes.SETTINGS,
      key: MainCubit.navigatorKeys[TabIndex.SETTINGS],
      onGenerateRoute: settingsRouteFactory,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    MainCubit.context = context;
    final selectedTab = context.select((MainCubit cubit) => cubit.state.tabIndex);
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab = !(await MainCubit.navigatorKeys[selectedTab]!.currentState!.maybePop());
        return isFirstRouteInCurrentTab;
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(
              // duration: const Duration(milliseconds: 150),
              // child: views[selectedTab.index],
              index: selectedTab.index,
              children: views,
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: _buildBottomNavigationBar(selectedTab),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(TabIndex selectedTab) => Builder(builder: (context) {
        final showBar = context.select((UserPrefCubit cubit) => cubit.state.showNavigationBar);
        return AnimatedCrossFade(
          sizeCurve: Curves.ease,
          duration: const Duration(milliseconds: 300),
          crossFadeState: showBar ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          secondChild: Container(),
          firstChild: Platform.isIOS
              ? _buildBottomNavigationBarBodyIOS(context, selectedTab)
              : _buildBottomNavigationBarBodyAndroid(context, selectedTab),
        );
      });

  Widget _buildBottomNavigationBarBodyIOS(BuildContext context, TabIndex selectedTab) {
    return AdaptiveBuilder(
      defaultBuilder: (context, _) => _buildRegularIOSBottomNavigationBar(context, selectedTab),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        tablet: (context, _) =>
            _buildRegularIOSBottomNavigationBar(context, selectedTab, AppColors.fullBlack.withOpacity(0.6)),
        desktop: (context, _) => _buildTabletBottomNavigationBar(context, selectedTab),
      ),
    );
  }

  Widget _buildBottomNavigationBarBodyAndroid(BuildContext context, TabIndex selectedTab) {
    return Material(
      color: AppColors.fullBlack,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _buildIcon(context, TabIndex.HOME, selectedTab),
            SizedBox(width: width(24)),
            _buildIcon(context, TabIndex.SETTINGS, selectedTab),
          ],
        ),
      ),
    );
  }

  Widget _buildRegularIOSBottomNavigationBar(BuildContext context, TabIndex selectedTab, [Color? color]) {
    return ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
          child: Material(
            color: color ?? AppColors.fullBlack.withOpacity(0.8),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  _buildIcon(context, TabIndex.HOME, selectedTab),
                  SizedBox(width: width(24)),
                  _buildIcon(context, TabIndex.SETTINGS, selectedTab),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Widget _buildTabletBottomNavigationBar(BuildContext context, TabIndex selectedTab) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: height(8), right: width(16)),
        child: Align(
          alignment: Alignment.centerRight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(width(14)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
              child: Container(
                height: height(65),
                width: ScreenUtil.screenWidthLp * 0.4,
                decoration: BoxDecoration(
                  color: AppColors.fullBlack.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(width(14)),
                ),
                padding: EdgeInsets.symmetric(horizontal: width(12)),
                child: Row(
                  children: [
                    _buildIcon(context, TabIndex.HOME, selectedTab),
                    SizedBox(width: width(24)),
                    _buildIcon(context, TabIndex.SETTINGS, selectedTab),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, TabIndex tab, TabIndex selectedTab) {
    final isSelected = tab == selectedTab;
    final color = isSelected ? Colors.white : Colors.white.withOpacity(0.4);
    return Expanded(
      child: BouncingWidget(
        minScale: 0.9,
        onTap: () {
          VibrationUtil.vibrate();
          context.read<MainCubit>().changeTab(tab, pop: true);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: height(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(tab.icon(context), color: color, size: tab.iconSize()),
              const SizedBox(height: 2),
              Text(tab.getName(),
                  style: context.textTheme.bodyLarge?.copyWith(
                    // fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontWeight: FontWeight.w500,
                    color: color,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

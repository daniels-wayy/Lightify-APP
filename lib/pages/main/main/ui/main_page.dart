import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightify/core/ui/bloc/user_pref/user_pref_cubit.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
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
      child: Column(
        children: [
          Expanded(
            child: IndexedStack(
              // duration: const Duration(milliseconds: 150),
              // child: views[selectedTab.index],
              index: selectedTab.index,
              children: views,
            ),
          ),
          _buildBottomNavigationBar(selectedTab),
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
          firstChild: Material(
            color: Colors.black,
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
        );
      });

  Widget _buildIcon(BuildContext context, TabIndex tab, TabIndex selectedTab) {
    final isSelected = tab == selectedTab;
    final color = isSelected ? Colors.white : Colors.white.withOpacity(0.4);
    return Expanded(
      child: BouncingWidget(
        minScale: 0.9,
        onTap: () => context.read<MainCubit>().changeTab(tab),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: height(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(tab.icon(context), color: color, size: tab.iconSize()),
              const SizedBox(height: 2),
              Text(tab.getName(),
                  style: context.textTheme.displaySmall?.copyWith(
                    fontSize: height(13),
                    fontWeight: FontWeight.w600,
                    color: color,
                    letterSpacing: -0.25,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

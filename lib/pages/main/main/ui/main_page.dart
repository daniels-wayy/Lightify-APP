import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightify/pages/main/main/ui/bloc/main_cubit.dart';
import 'package:lightify/core/ui/routes/home_routes.dart';
import 'package:lightify/core/ui/routes/settings_routes.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              index: selectedTab.value,
              children: [
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
              ],
            ),
          ),
          // _buildBottomNavigationBar(selectedTab),
        ],
      ),
    );
  }

  // Widget _buildBottomNavigationBar(TabIndex selectedTab) => Builder(builder: (context) {
  //       return Material(
  //         color: Colors.black,
  //         child: SafeArea(
  //           top: false,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: TabIndex.values.map((e) => _buildIcon(e, selectedTab)).toList(),
  //           ),
  //         ),
  //       );
  //     });

  // Widget _buildIcon(TabIndex tab, TabIndex selectedTab) {
  //   final isSelected = tab == selectedTab;
  //   final color = isSelected ? Colors.white : Colors.white.withOpacity(0.4);
  //   final icon = isSelected ? tab.getSelectedIcon() : tab.getUnselectedIcon();
  //   return Builder(builder: (context) {
  //     return CommonInkWell(
  //       onTap: () => context.read<MainCubit>().changeTab(tab),
  //       showHover: false,
  //       child: Padding(
  //         padding: EdgeInsets.symmetric(horizontal: width(64), vertical: height(8)),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(icon, color: color, size: height(24)),
  //             const SizedBox(height: 1),
  //             Text(tab.getName(), style: TextStyle(fontSize: height(10), color: color)),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }
}

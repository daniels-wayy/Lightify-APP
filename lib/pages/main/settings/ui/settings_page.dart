import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lightify/core/ui/bloc/user_pref/user_pref_cubit.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/widget/common/app_version_info_widget.dart';
import 'package:lightify/core/ui/widget/common/bouncing_widget.dart';
import 'package:lightify/core/ui/widget/common/custom_pop_scope.dart';
import 'package:lightify/core/ui/widget/common/fading_edge_widget.dart';
import 'package:lightify/core/ui/widget/common/title_switch_widget.dart';
import 'package:lightify/pages/main/main/ui/bloc/main_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
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
            SafeArea(
              bottom: false,
              child: Row(
                children: [
                  SizedBox(width: width(18)),
                  BouncingWidget(
                    onTap: () => MainCubit.context.read<MainCubit>().changeTab(TabIndex.HOME),
                    child: Icon(
                      PlatformIcons(context).back,
                      size: height(23),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: width(18)),
                  Text(
                    'Settings',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: height(21),
                      letterSpacing: -0.2,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: height(14)),
            Expanded(
              child: FadingEdge(
                scrollDirection: Axis.vertical,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: width(18), vertical: height(12)),
                  children: [
                    SizedBox(height: height(12)),
                    Builder(builder: (context) {
                      final value = context.select((UserPrefCubit cubit) => cubit.state.showNavigationBar);
                      return TitleSwitchWidget(
                        value: value,
                        title: 'Show navigation bar',
                        onChanged: context.read<UserPrefCubit>().onShowNavigationBarChanged,
                      );
                    }),
                    SizedBox(height: height(12)),
                    _buildDivider(),
                    SizedBox(height: height(12)),
                    Builder(builder: (context) {
                      final value = context.select((UserPrefCubit cubit) => cubit.state.showHomeSelectorBar);
                      return TitleSwitchWidget(
                        value: value,
                        title: 'Show home selector bar',
                        onChanged: context.read<UserPrefCubit>().onShowHomeSelectorBarChanged,
                      );
                    }),
                    SizedBox(height: height(102)),
                    Row(
                      children: [
                        Text(
                          'App details: ',
                          style: context.textTheme.titleSmall?.copyWith(
                            fontSize: height(18),
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const Spacer(),
                        const AppVersionInfo(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() => Container(
        width: double.maxFinite,
        height: 0.5,
        color: AppColors.gray100.withOpacity(.15),
      );
}

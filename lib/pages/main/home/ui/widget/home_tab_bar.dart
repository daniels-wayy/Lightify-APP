import 'package:flutter/material.dart';
import 'package:lightify/config.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/utils/vibration_util.dart';

class HomeTabBar extends TabBar {
  HomeTabBar({
    super.key,
    required BuildContext context,
    required TabController controller,
  }) : super(
          isScrollable: true,
          controller: controller,
          labelStyle: context.textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: context.textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w500),
          dividerColor: Colors.transparent,
          unselectedLabelColor: Colors.white54,
          padding: EdgeInsets.only(right: width(18)),
          indicatorPadding: EdgeInsets.zero,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.white,
          tabAlignment: TabAlignment.center,
          indicatorWeight: 1,
          labelColor: Colors.white,
          overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
          indicator: UnderlineTabIndicator(borderRadius: BorderRadius.circular(width(12))),
          onTap: (_) => VibrationUtil.vibrate(),
          tabs: Config.houses
              .map(
                (house) => Tab(
                  text: house.name,
                  iconMargin: EdgeInsets.zero,
                  height: height(48),
                ),
              )
              .toList(),
        );
}

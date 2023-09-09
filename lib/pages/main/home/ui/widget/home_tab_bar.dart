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
          labelStyle: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: height(20),
            letterSpacing: -0.5,
          ),
          unselectedLabelColor: Colors.white54,
          padding: EdgeInsets.only(right: width(18)),
          indicatorPadding: EdgeInsets.zero,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.white,
          indicatorWeight: 1,
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

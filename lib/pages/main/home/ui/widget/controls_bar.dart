import 'package:flutter/material.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/widget/common/bouncing_widget.dart';
import 'package:lightify/pages/main/home/ui/widget/icon_button_widget.dart';

class ControlsBar extends StatelessWidget {
  const ControlsBar({super.key, required this.onSleepMode, required this.onShutDown});

  final VoidCallback onSleepMode;
  final VoidCallback onShutDown;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(55),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: width(18)),
        scrollDirection: Axis.horizontal,
        children: [
          IconButtonWidget(
            icon: Icons.bedtime_outlined,
            color: AppColors.primary100,
            title: AppConstants.strings.SLEEP_MODE,
            padding: EdgeInsets.symmetric(horizontal: width(12)),
          ),
          SizedBox(width: width(12)),
          IconButtonWidget(
            icon: Icons.flashlight_off_outlined,
            color: AppColors.secondary100,
            title: AppConstants.strings.POWER_OFF,
            padding: EdgeInsets.symmetric(horizontal: width(12)),
          ),
        ],
      ),
    );
    // return Row(
    //   children: [
    //     Expanded(
    //       child: _buildItem(
    //         context: context,
    //         color1: AppColors.primary100,
    //         color2: AppColors.navy100,
    //         icon: Icons.bedtime_outlined,
    //         text: AppConstants.strings.SLEEP_MODE,
    //         onTap: onSleepMode,
    //       ),
    //     ),
    //     SizedBox(width: width(12)),
    //     Expanded(
    //       child: _buildItem(
    //         context: context,
    //         color1: AppColors.secondary100,
    //         color2: AppColors.secondary200,
    //         icon: Icons.flashlight_off_outlined,
    //         text: AppConstants.strings.SHUT_DOWN,
    //         onTap: onShutDown,
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget _buildItem({
    required BuildContext context,
    required Color color1,
    required Color color2,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return BouncingWidget(
      onTap: onTap,
      child: Container(
        height: height(64),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color1, color2], begin: Alignment.bottomLeft, end: Alignment.topRight),
          borderRadius: AppConstants.widget.defaultBorderRadius,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(right: width(6)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.white, size: width(26)),
                SizedBox(width: width(8)),
                Text(text,
                    style: context.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.15,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/widget/common/bouncing_widget.dart';

class IconButtonWidget extends StatelessWidget {
  const IconButtonWidget({
    super.key,
    this.onTap,
    this.buttonHeight = 60,
    this.padding,
    required this.color,
    required this.icon,
    required this.title,
  });

  final VoidCallback? onTap;
  final int buttonHeight;
  final Color color;
  final IconData icon;
  final String title;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onTap: onTap,
      child: Container(
        height: height(buttonHeight),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: AppConstants.widget.defaultBorderRadius,
        ),
        padding: padding,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(right: width(6)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.white, size: width(22)),
                SizedBox(width: width(8)),
                Text(title,
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

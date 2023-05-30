import 'package:flutter/material.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/screen_util.dart' as scr;
import 'package:lightify/core/ui/widget/common/bouncing_widget.dart';

class NoConnectionSnackbar extends SnackBar {
  NoConnectionSnackbar({super.key, required this.context, required this.onDismiss})
      : super(
          content: Container(
            margin: EdgeInsets.symmetric(horizontal: scr.width(18)).copyWith(
              bottom: scr.height(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: scr.width(14), vertical: scr.height(10)),
            decoration: BoxDecoration(
              color: AppColors.errorColor,
              borderRadius: AppConstants.widget.smallBorderRadius,
              boxShadow: [
                BoxShadow(
                  color: AppColors.errorShadow.withOpacity(.12),
                  offset: const Offset(0, 4),
                  blurRadius: scr.height(12),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.wifi_off_rounded, size: scr.height(22), color: AppColors.white),
                SizedBox(width: scr.width(6)),
                Text(AppConstants.strings.INTERNET_CONNECTION_LOST,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: AppColors.white,
                      letterSpacing: 0.0,
                    )),
                const Spacer(),
                BouncingWidget(
                  onTap: onDismiss,
                  child: Icon(Icons.close, size: scr.height(22), color: AppColors.gray400),
                ),
              ],
            ),
          ),
          padding: EdgeInsets.zero,
          duration: const Duration(minutes: 1),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        );

  final BuildContext context;
  final VoidCallback onDismiss;
}

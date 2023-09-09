import 'package:flutter/cupertino.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/di/di.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionInfo extends StatelessWidget {
  const AppVersionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final PackageInfo packageInfo = getIt<PackageInfo>();
    return Container(
      alignment: AlignmentDirectional.bottomStart,
      child: Text(
        '${packageInfo.packageName}: Version: ${packageInfo.version}, build: ${packageInfo.buildNumber}',
        style: context.textTheme.displayMedium?.copyWith(
          fontSize: height(15),
          color: AppColors.gray200,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.05,
        ),
      ),
    );
  }
}

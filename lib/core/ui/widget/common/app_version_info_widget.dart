import 'package:flutter/material.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
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
          color: Colors.grey.shade500,
        ),
      ),
    );
  }
}

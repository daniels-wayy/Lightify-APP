import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/widget/common/bouncing_widget.dart';
import 'package:lightify/pages/main/main/ui/bloc/main_cubit.dart';

class SettingsAppBar extends StatelessWidget {
  const SettingsAppBar({super.key, this.title, this.onBack});

  final String? title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Positioned(
            left: width(14),
            child: BouncingWidget(
              onTap: () => onBack != null ? onBack!() : MainCubit.context.read<MainCubit>().changeTab(TabIndex.HOME),
              child: Icon(
                PlatformIcons(context).back,
                size: height(26),
                color: Colors.white,
              ),
            ),
          ),
          Center(
            child: Text(
              title ?? 'Settings',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: height(21),
                letterSpacing: -0.6,
              ),
            ),
          )
        ],
      ),
    );
  }
}

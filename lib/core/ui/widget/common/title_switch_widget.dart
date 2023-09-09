import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/utils/vibration_util.dart';

class TitleSwitchWidget extends StatelessWidget {
  const TitleSwitchWidget({
    super.key,
    required this.title,
    required this.value,
    this.onChanged,
  });

  final String title;
  final bool value;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: context.textTheme.titleSmall?.copyWith(
            fontSize: height(18),
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
        ),
        const Spacer(),
        Switch.adaptive(
          value: value,
          onChanged: (value) {
            VibrationUtil.vibrate();
            onChanged?.call(value);
          },
          trackOutlineColor: MaterialStateColor.resolveWith(
            (states) {
              if (states.isNotEmpty && states.first == MaterialState.selected) {
                return Colors.transparent;
              }
              return AppColors.gray100.withOpacity(.6);
            },
          ),
        ),
      ],
    );
  }
}

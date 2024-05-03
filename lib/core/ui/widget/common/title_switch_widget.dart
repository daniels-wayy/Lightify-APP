import 'package:flutter/material.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
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
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Switch.adaptive(
          value: value,
          onChanged: (value) {
            VibrationUtil.vibrate();
            onChanged?.call(value);
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';

class SlideableTime extends StatelessWidget {
  const SlideableTime({
    super.key,
    required this.time,
    required this.color,
  });

  final DateTime time;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('HH:mm').format(time);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        formattedTime,
        key: ValueKey(formattedTime),
        style: context.textTheme.titleLarge?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 42,
        ),
      ),
    );
  }
}

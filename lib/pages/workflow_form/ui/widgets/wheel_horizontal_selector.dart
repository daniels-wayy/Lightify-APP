import 'package:flutter/material.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/utils/vibration_util.dart';
import 'package:lightify/core/ui/widget/common/fading_edge_widget.dart';

class WheelHorizontalSelector extends StatefulWidget {
  const WheelHorizontalSelector({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.count,
    this.mapper,
    this.colorMapper,
    this.squeeze = 0.95,
  });

  final int count;
  final FixedExtentScrollController controller;
  final void Function(int) onChanged;
  final String Function(int)? mapper;
  final Color Function(int)? colorMapper;
  final double squeeze;

  @override
  State<WheelHorizontalSelector> createState() => _WheelHorizontalSelectorState();
}

class _WheelHorizontalSelectorState extends State<WheelHorizontalSelector> {
  late final List<Widget> elements;

  @override
  void initState() {
    super.initState();
    elements = List.generate(widget.count, (index) => _Item(index, widget.mapper, widget.colorMapper));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(55),
      width: double.maxFinite,
      child: FadingEdge(
        stops: const [0.0, 0.4, 0.6, 1.0],
        scrollDirection: Axis.horizontal,
        child: RotatedBox(
          quarterTurns: -1,
          child: ListWheelScrollView.useDelegate(
            controller: widget.controller,
            itemExtent: 120,
            perspective: 0.00001,
            diameterRatio: 1.25,
            physics: const FixedExtentScrollPhysics(),
            squeeze: widget.squeeze,
            childDelegate: ListWheelChildListDelegate(children: elements),
            onSelectedItemChanged: (index) {
              VibrationUtil.vibrate();
              widget.onChanged(index);
            },
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final int value;
  final String Function(int)? mapper;
  final Color Function(int)? colorMapper;

  const _Item(this.value, this.mapper, this.colorMapper);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Center(
        child: RotatedBox(
          quarterTurns: 1,
          child: Text(
            mapper?.call(value) ?? value.toString(),
            style: context.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.normal,
              color: colorMapper?.call(value),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
      ),
    );
  }
}

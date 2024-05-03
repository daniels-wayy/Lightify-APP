import 'package:flutter/material.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/utils/vibration_util.dart';
import 'package:lightify/core/ui/widget/common/fading_edge_widget.dart';

class WheelTimeSelector extends StatefulWidget {
  const WheelTimeSelector({
    super.key,
    required this.onChanged,
    required this.hoursController,
    required this.minutesController,
  });

  final void Function(DateTime) onChanged;
  final FixedExtentScrollController hoursController;
  final FixedExtentScrollController minutesController;

  @override
  State<WheelTimeSelector> createState() => _WheelTimeSelectorState();
}

class _WheelTimeSelectorState extends State<WheelTimeSelector> {
  final nowDate = DateTime.now();
  final hours = List.generate(24, _Hour.new);
  final minutes = List.generate(60, _Minute.new);

  int currentHour = 0;
  int currentMinute = 0;

  void _buildDateTime() {
    VibrationUtil.vibrate();
    final dateTime = DateTime(
      nowDate.year,
      nowDate.month,
      nowDate.day,
      currentHour,
      currentMinute,
    );
    widget.onChanged(dateTime);
  }

  @override
  void initState() {
    super.initState();
    currentHour = widget.hoursController.initialItem;
    currentMinute = widget.minutesController.initialItem;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(230),
      width: double.maxFinite,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width(90),
                child: FadingEdge(
                  stops: const [0.0, 0.4, 0.6, 1.0],
                  scrollDirection: Axis.vertical,
                  child: ListWheelScrollView.useDelegate(
                    controller: widget.hoursController,
                    itemExtent: 50,
                    perspective: 0.005,
                    diameterRatio: 1.2,
                    physics: const FixedExtentScrollPhysics(),
                    overAndUnderCenterOpacity: 0.7,
                    squeeze: 1.2,
                    childDelegate: ListWheelChildLoopingListDelegate(children: hours),
                    onSelectedItemChanged: (i) {
                      currentHour = i;
                      _buildDateTime();
                    },
                  ),
                ),
              ),
              SizedBox(
                width: width(90),
                child: FadingEdge(
                  stops: const [0.0, 0.4, 0.6, 1.0],
                  scrollDirection: Axis.vertical,
                  child: ListWheelScrollView.useDelegate(
                    controller: widget.minutesController,
                    itemExtent: 50,
                    perspective: 0.005,
                    diameterRatio: 1.2,
                    physics: const FixedExtentScrollPhysics(),
                    overAndUnderCenterOpacity: 0.7,
                    squeeze: 1.2,
                    childDelegate: ListWheelChildLoopingListDelegate(children: minutes),
                    onSelectedItemChanged: (i) {
                      currentMinute = i;
                      _buildDateTime();
                    },
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: IgnorePointer(
              child: Container(
                width: double.maxFinite,
                height: 48.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Hour extends StatelessWidget {
  final int hours;

  const _Hour(this.hours);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Center(
        child: Text(
          hours < 10 ? '0$hours' : hours.toString(),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: height(28),
          ),
        ),
      ),
    );
  }
}

class _Minute extends StatelessWidget {
  final int mins;

  const _Minute(this.mins);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Center(
        child: Text(
          mins < 10 ? '0$mins' : mins.toString(),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: height(28),
          ),
        ),
      ),
    );
  }
}

import 'package:intl/intl.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/utils/function_util.dart';

class Workflow {
  static const everyWeekdaysNum = 7;
  static const everyWeekendsNum = 8;
  static const everydayNum = 9;

  static const maxDurationMin = 90;

  static const dayNameMapper = <int, String>{
    0: 'every Sunday',
    1: 'every Monday',
    2: 'every Tuesday',
    3: 'every Wednesday',
    4: 'every Thursday',
    5: 'every Firday',
    6: 'every Saturday',
    everyWeekdaysNum: 'every weekday',
    everyWeekendsNum: 'every weekend',
    everydayNum: 'everyday',
  };

  final int id;
  final bool isEnabled;
  final bool isPowerOn;
  final int day;
  final int hour;
  final int minute;
  final Duration duration;
  final int brightness;

  Workflow(
      {required this.id,
      required this.isEnabled,
      required this.isPowerOn,
      required this.day,
      required this.hour,
      required this.minute,
      required this.duration,
      required this.brightness});

  factory Workflow.mock() {
    return Workflow(
      id: 62,
      isEnabled: true,
      isPowerOn: true,
      day: 5,
      hour: 23,
      minute: 55,
      duration: const Duration(minutes: 0),
      brightness: 10,
    );
  }

  Workflow copyWith({
    final bool? isEnabled,
  }) =>
      Workflow(
          id: id,
          isEnabled: isEnabled ?? this.isEnabled,
          isPowerOn: isPowerOn,
          day: day,
          hour: hour,
          minute: minute,
          duration: duration,
          brightness: brightness);

  int get durationMin => duration.inMinutes;

  DateTime get dateTime {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
  }

  String toStringData() {
    return '$id,${isEnabled.intState},${isPowerOn.intState},$day,$hour,$minute,$durationMin,$brightness';
  }

  String get whatTimeText {
    final time = DateFormat('HH:mm').format(dateTime);
    return time;
  }

  String get whatPowerText {
    if (brightness <= 0) {
      return durationMin > 0 ? 'Smoothly turn off' : 'Turn off';
    }

    final percent = brightnessPercent;
    return 'Dim to $percent%';
  }

  String get whatDaysText {
    return dayNameMapper[day] ?? '';
  }

  int get brightnessPercent {
    return FunctionUtil.fromBrightnessToPercent(brightness);
  }
}

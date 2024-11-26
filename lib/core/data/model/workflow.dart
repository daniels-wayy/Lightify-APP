import 'package:intl/intl.dart';
import 'package:lightify/core/data/model/device.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/utils/date_time_util.dart';
import 'package:lightify/core/ui/utils/function_util.dart';

class Workflow {
  static const everyWeekdaysNum = 7;
  static const everyWeekendsNum = 8;
  static const everydayNum = 9;

  static const maxDurationMin = 90;
  static const overviewTextNoticeHours = 2; // display before at least "n" hours 

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
  final int day;
  final int hour;
  final int minute;
  final Duration duration;
  final int brightness;

  Workflow(
      {required this.id,
      required this.isEnabled,
      required this.day,
      required this.hour,
      required this.minute,
      required this.duration,
      required this.brightness});

  factory Workflow.mock() {
    return Workflow(
      id: 62,
      isEnabled: true,
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
          day: day,
          hour: hour,
          minute: minute,
          duration: duration,
          brightness: brightness);

  int get durationMin => duration.inMinutes;

  int get minutesRemaining {
    return relativeDateTime.difference(DateTimeUtil.nowAbsoluteDate()).inMinutes;
  }

  DateTime get relativeDateTime {
    final date = nonRelativeDateTime;
    final dif = date.difference(DateTimeUtil.nowAbsoluteDate()).inMinutes;
    return date.add(Duration(days: dif <= 0 ? 1 : 0));
  }

  DateTime get nonRelativeDateTime {
    final now = DateTimeUtil.nowAbsoluteDate();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  DateTime get startTime {
    final time = nonRelativeDateTime;
    return time.subtract(duration);
  }

  DateTime get endTime {
    return startTime.add(duration);
  }

  bool get isDay {
    final now = DateTimeUtil.nowAbsoluteDate();
    final nowWeekday = isoToNtpWeekday(now.weekday);
    return /*if everyday*/ day == everydayNum ||
        /*if same day*/ day == nowWeekday ||
        /*if weekday*/ day == everyWeekdaysNum && (nowWeekday > 0 && nowWeekday < 6) ||
        /*if weekend*/ day == everyWeekendsNum && (nowWeekday == 6 || nowWeekday == 0);
  }

  bool get isTime {
    final now = DateTimeUtil.nowAbsoluteDate();
    return (now.isAfter(startTime.subtract(const Duration(seconds: 1))) && now.isBefore(endTime));
  }

  bool get isRunning {
    return isEnabled && isDay && isTime;
  }

  String toMqttPacket() {
    return '$id,${isEnabled.intState},$day,$hour,$minute,$durationMin,$brightness';
  }

  String get whatTimeText {
    final time = DateFormat('HH:mm').format(relativeDateTime);
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

  bool get showOverviewText {
    final minutes = minutesRemaining;
    final showOverview = minutes <= overviewTextNoticeHours * 60; // 4 hours
    return isEnabled && isDay && showOverview;
  }

  String overviewText(Device device) {
    final workflowTime = relativeDateTime;
    final minutes = minutesRemaining;
    final showInMinutes = minutes > 0 && minutes < 60;
    final isRun = isRunning;

    var result = '${isRun ? 'Running' : 'Upcoming'} ';
    result += brightness <= 0
        ? 'fade out'
        // : 'fade ${device.brightnessPercent < brightnessPercent ? 'in' : 'out'} to $brightnessPercent%';
        : 'dim to $brightnessPercent%';
    result += ' ';

    final formatEndingTime = DateFormat.Hm().format(workflowTime);

    if (showInMinutes) {
      result += '${isRun ? 'within' : 'in'} $minutes ${minutes > 1 ? 'minutes' : 'minute'}';
    } else if (durationMin <= 0) {
      result += 'at $formatEndingTime';
    } else {
      final startingTime = workflowTime.subtract(Duration(minutes: durationMin));
      final formatStartingTime = DateFormat.Hm().format(startingTime);
      result += 'from $formatStartingTime to $formatEndingTime';
    }
    return result;
  }

  int isoToNtpWeekday(int isoWeekday) {
    return isoWeekday != 7 ? isoWeekday : 0;
  }

  @override
  String toString() {
    return 'Workflow($id, ${isEnabled ? 'enabled' : 'disabled'}, time: $hour:$minute, day: ${dayNameMapper[day]}, duration: ${durationMin}min)';
  }
}

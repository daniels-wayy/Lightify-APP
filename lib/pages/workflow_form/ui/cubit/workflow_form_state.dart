part of 'workflow_form_cubit.dart';

@freezed
class WorkflowFormState with _$WorkflowFormState {
  const WorkflowFormState._();
  const factory WorkflowFormState({
    @Default(0) int day,
    @Default(0) int hour,
    @Default(0) int minute,
    @Default(0) int duration,
    @Default(0) int brightness,
    @Default(<Device>[]) List<Device> selectedDevices,
  }) = _WorkflowFormState;

  factory WorkflowFormState.initial({
    required Workflow? workflow,
    required Device currentDevice,
  }) =>
      WorkflowFormState(
        day: _getInitialDay(workflow),
        hour: _getInitialHour(workflow),
        minute: _getInitialMinute(workflow),
        duration: _getInitialDuration(workflow),
        brightness: _getInitialBrightness(workflow),
        selectedDevices: [currentDevice],
      );

  static int _getInitialDay(Workflow? workflow) {
    if (workflow == null) {
      final now = DateTime.now();
      if (now.weekday == 6 || now.weekday == 7) {
        return Workflow.everyWeekendsNum;
      }
      return Workflow.everyWeekdaysNum;
    }
    return workflow.day;
  }

  static int _getInitialHour(Workflow? workflow) {
    return workflow != null ? workflow.hour : DateTime.now().hour;
  }

  static int _getInitialMinute(Workflow? workflow) {
    return workflow != null ? workflow.minute : DateTime.now().minute;
  }

  static int _getInitialDuration(Workflow? workflow) {
    return workflow != null ? workflow.durationMin : WorkflowFormCubit.defaultDuration;
  }

  static int _getInitialBrightness(Workflow? workflow) {
    return workflow != null
        ? FunctionUtil.fromBrightnessToPercent(workflow.brightness)
        : WorkflowFormCubit.defaultBrightness;
  }

  String overviewText() {
    var result = '';

    if (brightness <= 0) {
      result += duration > 0 ? 'Smoothly turn off' : 'Turn off';
    } else {
      result += 'Dim to $brightness%';
    }

    result += ' ';
    result += Workflow.dayNameMapper[day] ?? '';

    result += '\n';

    final now = DateTime.now();
    final endingTime = DateTime(now.year, now.month, now.day, hour, minute);
    final formatEndingTime = DateFormat.Hm().format(endingTime);

    if (duration <= 0) {
      result += 'at $formatEndingTime';
    } else {
      final startingTime = endingTime.subtract(Duration(minutes: duration));
      final formatStartingTime = DateFormat.Hm().format(startingTime);
      result += 'starting from $formatStartingTime to $formatEndingTime';
    }

    return result;
  }

  int get currentId {
    return day + hour + minute + duration + (brightness ~/ 10);
  }
}

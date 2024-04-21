import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightify/core/data/model/workflow.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/dialog_util.dart';
import 'package:lightify/core/ui/utils/function_util.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/widget/common/bouncing_widget.dart';
import 'package:lightify/core/ui/widget/common/custom_pop_scope.dart';
import 'package:lightify/core/ui/widget/common/fading_edge_widget.dart';
import 'package:lightify/pages/workflow_form/domain/args/workflow_form_page_args.dart';
import 'package:lightify/pages/workflow_form/ui/cubit/workflow_form_cubit.dart';
import 'package:lightify/pages/workflow_form/ui/widgets/wheel_horizontal_selector.dart';
import 'package:lightify/pages/workflow_form/ui/widgets/wheel_time_selector.dart';

class WorkflowFormPage extends StatefulWidget {
  const WorkflowFormPage({super.key, required this.args});

  final WorkflowFormPageArgs args;

  @override
  State<WorkflowFormPage> createState() => _WorkflowFormPageState();
}

class _WorkflowFormPageState extends State<WorkflowFormPage> {
  late FixedExtentScrollController hoursController;
  late FixedExtentScrollController minutesController;
  late FixedExtentScrollController repeatController;
  late FixedExtentScrollController durationController;
  late FixedExtentScrollController brightnessController;

  bool get isEdit => widget.args.workflow != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<WorkflowFormCubit>().state;
    hoursController = FixedExtentScrollController(initialItem: state.hour);
    minutesController = FixedExtentScrollController(initialItem: state.minute);
    repeatController = FixedExtentScrollController(initialItem: state.day);
    durationController = FixedExtentScrollController(initialItem: state.duration);
    brightnessController =
        FixedExtentScrollController(initialItem: state.brightness ~/ WorkflowFormCubit.brightnessScaleDivisions);
  }

  @override
  void dispose() {
    super.dispose();
    hoursController.dispose();
    minutesController.dispose();
    repeatController.dispose();
    durationController.dispose();
    brightnessController.dispose();
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: BouncingWidget(
        onTap: _back,
        child: Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: height(22)),
      ),
      backgroundColor: AppColors.fullBlack,
      centerTitle: true,
      elevation: 0.0,
      toolbarHeight: kToolbarHeight + height(20),
      title: Text(
        '${isEdit ? 'Edit' : 'Add'} Workflow',
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: height(21),
          letterSpacing: -0.6,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      onWillPop: () {
        _back();
        return Future.value(false);
      },
      child: Scaffold(
          appBar: _buildAppBar(context),
          backgroundColor: AppColors.fullBlack,
          body: FadingEdge(
            scrollDirection: Axis.vertical,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: width(16)),
              children: [
                SizedBox(height: height(14)),
                WheelTimeSelector(
                  onChanged: _onTimeChanged,
                  hoursController: hoursController,
                  minutesController: minutesController,
                ),
                SizedBox(height: height(18)),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width(18), vertical: height(18)),
                    child: Column(
                      children: [
                        _buildRepeat(),
                        SizedBox(height: height(18)),
                        const Divider(),
                        SizedBox(height: height(18)),
                        _buildDuration(),
                        SizedBox(height: height(18)),
                        const Divider(),
                        SizedBox(height: height(18)),
                        _buildBrightness(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height(18)),
                _buildOverview(),
                SizedBox(height: height(18)),
                if (isEdit) _buildDelete() else _buildAdd(),
                SizedBox(height: height(32)),
              ],
            ),
          )),
    );
  }

  Widget _buildRepeat() {
    return Row(
      children: [
        Text(
          'Repeat',
          style: context.textTheme.displayMedium?.copyWith(
            fontSize: height(16),
            color: Colors.white.withOpacity(0.6),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
          ),
        ),
        SizedBox(width: width(52)),
        Expanded(
          child: WheelHorizontalSelector(
            squeeze: 1.3,
            controller: repeatController,
            onChanged: _onRepeatChanged,
            count: Workflow.dayNameMapper.length,
            mapper: (i) {
              final value = Workflow.dayNameMapper[i];
              if (value != null) {
                final splitted = value.split(' ');
                return splitted.join('\n');
              }
              return '';
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDuration() {
    return Row(
      children: [
        Text(
          'Duration',
          style: context.textTheme.displayMedium?.copyWith(
            fontSize: height(16),
            color: Colors.white.withOpacity(0.6),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
          ),
        ),
        SizedBox(width: width(40)),
        Expanded(
          child: WheelHorizontalSelector(
            squeeze: 1.55,
            controller: durationController,
            onChanged: _onDurationChanged,
            count: Workflow.maxDurationMin + 1,
            mapper: (i) => '${i}min',
          ),
        ),
      ],
    );
  }

  Widget _buildBrightness() {
    return Row(
      children: [
        Text(
          'Brightness',
          style: context.textTheme.displayMedium?.copyWith(
            fontSize: height(16),
            color: Colors.white.withOpacity(0.6),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
          ),
        ),
        SizedBox(width: width(28)),
        Expanded(
          child: WheelHorizontalSelector(
            squeeze: 1.55,
            controller: brightnessController,
            onChanged: _onBrightnessChanged,
            count: (100 ~/ WorkflowFormCubit.brightnessScaleDivisions) + 1,
            mapper: (i) => i == 0 ? 'Turn off' : '${i * WorkflowFormCubit.brightnessScaleDivisions}%',
            colorMapper: (i) {
              final value = i * WorkflowFormCubit.brightnessScaleDivisions;
              final scalar = value / 100;
              return WorkflowFormCubit.brightnessGradientSequence.transform(scalar) ?? Colors.white;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOverview() {
    return Center(
      child: BlocBuilder<WorkflowFormCubit, WorkflowFormState>(builder: (context, state) {
        return Text(
          state.overviewText(),
          style: context.textTheme.displayMedium?.copyWith(
            fontSize: height(12),
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.05,
          ),
          textAlign: TextAlign.center,
        );
      }),
    );
  }

  Widget _buildDelete() {
    return BouncingWidget(
      bounceOnTap: true,
      onTap: () {
        Navigator.of(context).pop();
        widget.args.onDelete?.call();
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey.shade400.withOpacity(0.04),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(18), vertical: height(18)),
          child: Center(
            child: Text(
              'Delete',
              style: context.textTheme.displayMedium?.copyWith(
                fontSize: height(14),
                color: Colors.red,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdd() {
    return BouncingWidget(
      bounceOnTap: true,
      onTap: _onAdd,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey.shade400.withOpacity(0.04),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(18), vertical: height(18)),
          child: Center(
            child: Text(
              'Add',
              style: context.textTheme.displayMedium?.copyWith(
                fontSize: height(14),
                color: Colors.green,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _onTimeChanged(DateTime time) {
    context.read<WorkflowFormCubit>().onTimeChanged(time);
  }

  void _onRepeatChanged(int i) {
    context.read<WorkflowFormCubit>().onRepeatChanged(i);
  }

  void _onDurationChanged(int i) {
    context.read<WorkflowFormCubit>().onDurationChanged(i);
  }

  void _onBrightnessChanged(int i) {
    context.read<WorkflowFormCubit>().onBrightnessChanged(i);
  }

  void _onAdd() {
    final state = context.read<WorkflowFormCubit>().state;
    final id = min(255, state.currentId + (Random().nextInt(40)));
    if (!widget.args.isExist(id)) {
      final workflow = Workflow(
        id: id,
        isEnabled: true,
        day: state.day,
        hour: state.hour,
        minute: state.minute,
        duration: Duration(minutes: state.duration),
        brightness: FunctionUtil.fromPercentToBrightness(state.brightness),
      );
      Navigator.of(context).pop(workflow);
    } else {
      DialogUtil.showToast('This workflow has already been added');
    }
  }

  bool isUnderstood = false;

  void _back() {
    if (isEdit) {
      final state = context.read<WorkflowFormCubit>().state;
      final id = state.currentId;

      if (id == widget.args.workflow!.id) {
        Navigator.of(context).pop();
        return;
      }

      if (!widget.args.isExist(id)) {
        Navigator.of(context).pop(Workflow(
          id: widget.args.workflow!.id,
          isEnabled: widget.args.workflow!.isEnabled,
          day: state.day,
          hour: state.hour,
          minute: state.minute,
          duration: Duration(minutes: state.duration),
          brightness: FunctionUtil.fromPercentToBrightness(state.brightness),
        ));
      } else {
        if (!isUnderstood) {
          isUnderstood = true;
          DialogUtil.showToast('Workflow with same properties has already been added');
        } else {
          Navigator.of(context).pop();
        }
      }
    } else {
      Navigator.of(context).pop();
    }
  }
}

part of 'package:lightify/pages/device_details/ui/device_details_page.dart';

class _WorkflowItem extends StatelessWidget {
  const _WorkflowItem({
    super.key,
    required this.workflow,
    required this.onSwitchTap,
    required this.onTap,
    required this.onDelete,
  });

  final Workflow workflow;
  final void Function(Workflow) onSwitchTap;
  final void Function(Workflow) onTap;
  final void Function(Workflow) onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: key,
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(workflow),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: PlatformIcons(context).delete,
            label: AppConstants.strings.DELETE,
          ),
        ],
      ),
      child: Column(
        children: [
          BouncingWidget(
            minScale: 0.96,
            onTap: () => onTap(workflow),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width(18), vertical: height(16)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTimeInfo(context),
                        const SizedBox(height: 2),
                        _buildSubtitle(context),
                      ],
                    ),
                  ),
                  _buildSwitch(context),
                ],
              ),
            ),
          ),
          const Divider(indent: 18),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(BuildContext context) {
    return Row(
      children: [
        SlideableTime(
          time: workflow.dateTime,
          color: workflow.isEnabled ? Colors.white : Colors.white60,
        ),
        if (workflow.durationMin > 0) ...[
          const SizedBox(width: 4),
          Text(
            '(',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade400.withOpacity(0.5),
              fontSize: 28,
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              '${workflow.durationMin}',
              key: ValueKey('${workflow.durationMin}'),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade400.withOpacity(0.5),
                fontSize: 28,
              ),
            ),
          ),
          const SizedBox(width: 1),
          Transform.translate(
            offset: const Offset(0.0, 3.0),
            child: Text(
              'min',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade400.withOpacity(0.5),
                fontSize: 18,
              ),
            ),
          ),
          Text(
            ')',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade400.withOpacity(0.5),
              fontSize: 28,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    final text = '${workflow.whatPowerText},  ${workflow.whatDaysText}';

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        text,
        key: ValueKey(text),
        style: context.textTheme.displayMedium?.copyWith(
          fontSize: height(13),
          color: workflow.isEnabled ? Colors.white : Colors.white60,
          fontWeight: FontWeight.normal,
          letterSpacing: -0.1,
        ),
      ),
    );
  }

  Widget _buildSwitch(BuildContext context) {
    return Switch.adaptive(
      value: workflow.isEnabled,
      onChanged: (value) {
        VibrationUtil.vibrate();
        onSwitchTap(workflow);
      },
      trackOutlineColor: MaterialStateColor.resolveWith(
        (states) {
          if (states.isNotEmpty && states.first == MaterialState.selected) {
            return Colors.transparent;
          }
          return AppColors.gray100.withOpacity(.6);
        },
      ),
      thumbColor: Platform.isAndroid
          ? MaterialStateColor.resolveWith(
              (states) {
                if (!states.contains(MaterialState.selected)) {
                  return Colors.black;
                }
                return Colors.white;
              },
            )
          : null,
    );
  }
}

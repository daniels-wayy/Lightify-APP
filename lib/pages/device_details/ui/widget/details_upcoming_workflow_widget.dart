part of 'package:lightify/pages/device_details/ui/device_details_page.dart';

class _DetailsUpcomingWorkflow extends StatelessWidget {
  const _DetailsUpcomingWorkflow(this.device);

  final Device device;

  static const animationDuration = Duration(milliseconds: 400);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceWorkflowsCubit, DeviceWorkflowsState>(
      builder: (context, state) {
        return Center(
          child: AnimatedCrossFade(
            crossFadeState: state.workflows.isEmpty ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: animationDuration,
            sizeCurve: Curves.easeInOut,
            firstCurve: Curves.ease,
            secondCurve: Curves.ease,
            alignment: Alignment.center,
            secondChild: Container(),
            firstChild: AnimatedOpacity(
              opacity: 1.0,
              curve: Curves.ease,
              duration: animationDuration,
              child: _buildDetails(context, state),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetails(BuildContext context, DeviceWorkflowsState state) {
    final now = DateTimeUtil.nowAbsoluteDate();
    final upcomingWorkflow = state.workflows.isEmpty
        ? Workflow.mock()
        : state.workflows.reduce(
            (a, b) {
              final aTimeDif = a.relativeDateTime.difference(now).inMinutes;
              final bTimeDif = b.relativeDateTime.difference(now).inMinutes;
              return aTimeDif < bTimeDif ? a : b;
            },
          );
    if (!upcomingWorkflow.showOverviewText) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        SizedBox(height: height(2)),
        Text(
          upcomingWorkflow.overviewText(device),
          style: context.textTheme.displayMedium?.copyWith(
            fontSize: height(12),
            color: Colors.grey.shade300.withOpacity(0.65),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

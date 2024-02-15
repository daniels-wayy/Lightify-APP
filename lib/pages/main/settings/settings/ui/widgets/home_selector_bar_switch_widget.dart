part of 'package:lightify/pages/main/settings/settings/ui/settings_page.dart';

class _HomeSelectorBarSwitch extends StatelessWidget {
  const _HomeSelectorBarSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final value = context.select((UserPrefCubit cubit) => cubit.state.showHomeSelectorBar);
      return TitleSwitchWidget(
        value: value,
        title: 'Show home selector bar',
        onChanged: context.read<UserPrefCubit>().onShowHomeSelectorBarChanged,
      );
    });
  }
}

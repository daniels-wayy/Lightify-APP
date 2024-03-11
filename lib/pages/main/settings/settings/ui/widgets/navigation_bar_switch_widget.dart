part of 'package:lightify/pages/main/settings/settings/ui/settings_page.dart';

class _NavigationBarSwitch extends StatelessWidget {
  const _NavigationBarSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final value = context.select((UserPrefCubit cubit) => cubit.state.showNavigationBar);
      return TitleSwitchWidget(
        value: value,
        title: 'Show navigation bar',
        onChanged: context.read<UserPrefCubit>().onShowNavigationBarChanged,
      );
    });
  }
}

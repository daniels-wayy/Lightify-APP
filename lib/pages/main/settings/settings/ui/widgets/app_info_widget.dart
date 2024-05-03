part of 'package:lightify/pages/main/settings/settings/ui/settings_page.dart';

class _AppInfo extends StatelessWidget {
  const _AppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'App details: ',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        const AppVersionInfo(),
      ],
    );
  }
}

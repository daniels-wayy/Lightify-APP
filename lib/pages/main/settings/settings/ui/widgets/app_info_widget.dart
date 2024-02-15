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
            fontSize: height(18),
            fontWeight: FontWeight.w500,
            letterSpacing: -0.6,
          ),
        ),
        const Spacer(),
        const AppVersionInfo(),
      ],
    );
  }
}

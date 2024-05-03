part of 'package:lightify/pages/main/settings/settings/ui/settings_page.dart';

class _HomeWidgetsPrefBarWidget extends StatelessWidget {
  const _HomeWidgetsPrefBarWidget({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Home widgets',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        BouncingWidget(
          onTap: onTap,
          bounceOnTap: true,
          minScale: 0.95,
          child: const HomeWidgetSmall(),
        ),
      ],
    );
  }
}

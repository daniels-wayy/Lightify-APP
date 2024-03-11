import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightify/core/ui/bloc/home_widgets_config/home_widgets_config_cubit.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/widget/common/custom_pop_scope.dart';
import 'package:lightify/core/ui/widget/common/fading_edge_widget.dart';
import 'package:lightify/pages/main/settings/home_widgets/ui/widgets/page_widgets/big_widget_page.dart';
import 'package:lightify/pages/main/settings/home_widgets/ui/widgets/page_widgets/medium_widget_page.dart';
import 'package:lightify/pages/main/settings/home_widgets/ui/widgets/page_widgets/small_widget_page.dart';
import 'package:lightify/pages/main/settings/settings/ui/widgets/settings_app_bar_widget.dart';

class HomeWidgetsPage extends StatefulWidget {
  const HomeWidgetsPage({super.key});

  @override
  State<HomeWidgetsPage> createState() => _HomeWidgetsPageState();
}

class _HomeWidgetsPageState extends State<HomeWidgetsPage> {
  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: AppColors.fullBlack,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height(26)),
            SettingsAppBar(title: 'Home widgets', onBack: Navigator.of(context).pop),
            SizedBox(height: height(14)),
            Expanded(
              child: FadingEdge(
                scrollDirection: Axis.vertical,
                child: BlocBuilder<HomeWidgetsConfigCubit, HomeWidgetsConfigState>(builder: (context, configState) {
                  return PageView(
                    children: [
                      SmallWidgetPage(
                        selectedDevices: configState.smallWidget,
                        onTap: context.read<HomeWidgetsConfigCubit>().smallDevicesSelectionChanged,
                      ),
                      MediumWidgetPage(
                        selectedDevices: configState.mediumWidget,
                        onTap: context.read<HomeWidgetsConfigCubit>().mediumDevicesSelectionChanged,
                      ),
                      BigWidgetPage(
                        selectedDevices: configState.bigWidget,
                        onTap: context.read<HomeWidgetsConfigCubit>().bigDevicesSelectionChanged,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

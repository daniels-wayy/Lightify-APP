import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightify/core/ui/bloc/home_widgets_config/home_widgets_config_cubit.dart';
import 'package:lightify/pages/main/settings/home_widgets/ui/widgets/home_widget_variants/home_widget_device_item_widget.dart';
import 'package:lightify/pages/main/settings/home_widgets/ui/widgets/home_widget_variants/home_widget_variant.dart';

class HomeWidgetSmall extends StatelessWidget {
  const HomeWidgetSmall({super.key, this.variant = HomeWidgetVariant.smallest});

  final HomeWidgetVariant variant;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: variant.widgetSize,
      height: variant.widgetSize,
      decoration: BoxDecoration(
        color: Colors.grey.shade500.withOpacity(0.15),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: BlocBuilder<HomeWidgetsConfigCubit, HomeWidgetsConfigState>(builder: (context, configState) {
        return GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: configState.smallWidget.map((e) => HomeWidgetDeviceItem(deviceEntity: e, variant: variant)).toList(),
        );
      }),
    );
  }
}

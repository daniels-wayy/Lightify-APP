import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightify/core/ui/bloc/home_widgets_config/home_widgets_config_cubit.dart';
import 'package:lightify/pages/main/settings/home_widgets/ui/widgets/home_widget_variants/home_widget_device_item_widget.dart';
import 'package:lightify/pages/main/settings/home_widgets/ui/widgets/home_widget_variants/home_widget_variant.dart';

class HomeWidgetBig extends StatelessWidget {
  const HomeWidgetBig({super.key});

  static const width = 174 * 2.0;
  static const height = 180 * 2.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade500.withOpacity(0.15),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: BlocBuilder<HomeWidgetsConfigCubit, HomeWidgetsConfigState>(builder: (context, configState) {
        return GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          crossAxisCount: 4,
          mainAxisSpacing: 40,
          crossAxisSpacing: 8,
          children: configState.bigWidget
              .map((e) => HomeWidgetDeviceItem(
                    deviceEntity: e,
                    variant: HomeWidgetVariant.bigger,
                    addBrightness: true,
                  ))
              .toList(),
        );
      }),
    );
  }
}

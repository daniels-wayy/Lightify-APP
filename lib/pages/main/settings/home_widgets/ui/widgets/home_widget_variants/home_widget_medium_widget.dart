import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightify/core/ui/bloc/home_widgets_config/home_widgets_config_cubit.dart';
import 'package:lightify/pages/main/settings/home_widgets/ui/widgets/home_widget_variants/home_widget_device_item_widget.dart';
import 'package:lightify/pages/main/settings/home_widgets/ui/widgets/home_widget_variants/home_widget_variant.dart';

class HomeWidgetMedium extends StatelessWidget {
  const HomeWidgetMedium({super.key});

  static const width = 174.0 * 2.0;
  static const height = 180.0;

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
      child: Center(
        child: BlocBuilder<HomeWidgetsConfigCubit, HomeWidgetsConfigState>(builder: (context, configState) {
          // return SizedBox(
          //   width: double.maxFinite,
          //   height: double.maxFinite,
          //   child: ListView.separated(
          //     // shrinkWrap: true,
          //     physics: const NeverScrollableScrollPhysics(),
          //     scrollDirection: Axis.horizontal,
          //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          //     itemBuilder: (context, index) => HomeWidgetDeviceItem(
          //         deviceEntity: configState.mediumWidget[index], variant: HomeWidgetVariant.bigger, addBrightness: true),
          //     separatorBuilder: (_, __) => const SizedBox(width: 8),
          //     itemCount: configState.mediumWidget.length,
          //   ),
          // );
          return GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8).copyWith(
              bottom: 38,
            ),
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            shrinkWrap: true,
            children: configState.mediumWidget
                .map((e) => HomeWidgetDeviceItem(deviceEntity: e, variant: HomeWidgetVariant.bigger, addBrightness: true))
                .toList(),
          );
        }),
      ),
    );
  }
}

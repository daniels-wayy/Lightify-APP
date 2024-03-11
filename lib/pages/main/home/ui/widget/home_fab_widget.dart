import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/widget/common/bouncing_widget.dart';
import 'package:lightify/pages/main/main/ui/bloc/main_cubit.dart';

class HomeFAB extends StatelessWidget {
  const HomeFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onTap: () => MainCubit.context.read<MainCubit>().changeTab(TabIndex.SETTINGS),
      child: Container(
        width: width(50),
        height: width(50),
        margin: EdgeInsets.symmetric(horizontal: width(3)),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: AppConstants.widget.mediumBorderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.55),
              blurRadius: 10.0,
              offset: Offset.zero,
            ),
          ],
        ),
        child: Icon(
          PlatformIcons(context).settings,
          size: height(24),
          color: Colors.white,
        ),
      ),
    );
  }
}

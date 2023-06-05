import 'package:flutter/material.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/widget/common/bouncing_widget.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({super.key, required this.error, this.onRetry});

  final String error;
  final void Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.fullBlack,
            AppColors.fullBlack.withBlue(10).withRed(10).withOpacity(0.4),
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height(124)),
              const Spacer(),
              Icon(
                Icons.error_outline,
                size: height(64),
                color: Colors.white,
              ),
              SizedBox(height: height(16)),
              Text(
                AppConstants.strings.AN_ERROR_OCCURED,
                style: context.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: height(8)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width(24)),
                child: Text(
                  '$error.\n${AppConstants.strings.CHECK_YOUR_INTERNET_CONNECITON_OR_TRY_AGAIN}',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.gray300,
                    height: 1.65,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              BouncingWidget(
                onTap: onRetry,
                child: Column(
                  children: [
                    Container(
                      width: width(42),
                      height: width(42),
                      decoration: BoxDecoration(border: Border.all(color: AppColors.gray200), shape: BoxShape.circle),
                      child: const Center(
                          child: Icon(
                        Icons.refresh,
                        color: AppColors.gray200,
                      )),
                    ),
                    SizedBox(height: height(8)),
                    Text(
                      AppConstants.strings.RETRY,
                      style: context.textTheme.displaySmall?.copyWith(color: AppColors.gray200),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height(124)),
            ],
          ),
        ),
      ),
    );
  }
}

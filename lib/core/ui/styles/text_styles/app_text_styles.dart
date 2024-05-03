import 'package:flutter/material.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const double textScaleFactorLowerLimit = 0.85; // const font size min scale
  static const double textScaleFactorUpperLimit = 0.85; // const font size max scale

  static TextStyle defaultStyle() {
    return const TextStyle(
      fontFamily: 'Montserrat',
      letterSpacing: -0.1,
    );
  }

  static TextStyle displaySmall() {
    return defaultStyle().copyWith(
      color: AppColors.white,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle displayMedium() {
    return defaultStyle().copyWith(
      color: AppColors.white,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle displayLarge() {
    return defaultStyle().copyWith(
      color: AppColors.white,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle bodySmall() {
    return defaultStyle().copyWith(
      color: AppColors.white,
      fontSize: 10,
      fontWeight: FontWeight.w300,
      letterSpacing: 0.25,
    );
  }

  static TextStyle bodyMedium() {
    return defaultStyle().copyWith(
      color: AppColors.white,
      fontSize: 10,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle bodyLarge() {
    return defaultStyle().copyWith(
      color: AppColors.white,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle titleSmall() {
    return defaultStyle().copyWith(
      color: AppColors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle titleMedium() {
    return defaultStyle().copyWith(
      color: AppColors.white,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    );
  }

  static TextStyle titleLarge() {
    return defaultStyle().copyWith(
      color: AppColors.white,
      fontSize: 22,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle labelLarge() {
    return defaultStyle().copyWith(
      color: AppColors.white,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
  }
}

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/formatters/input_formatters.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';

class AppInput extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final String? hint;
  final TextStyle? hintStyle;
  final int? maxLength;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final bool capitalizeFirstLetter;

  const AppInput({
    super.key,
    this.controller,
    this.textInputType,
    this.hint,
    this.hintStyle,
    this.maxLength,
    this.onChanged,
    this.textInputAction,
    this.capitalizeFirstLetter = false,
  });

  String get getHint => hint ?? 'Enter value';

  List<TextInputFormatter> get getFormatters {
    final List<TextInputFormatter> formatters = [];
    if (capitalizeFirstLetter) {
      formatters.add(FirstUpperCaseTextFormatter());
    }
    return formatters;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoTextField(
        onChanged: onChanged,
        maxLength: maxLength,
        controller: controller,
        keyboardType: textInputType,
        placeholder: getHint,
        placeholderStyle: hintStyle,
        style: context.textTheme.displayLarge,
        cursorColor: AppColors.white64,
        textInputAction: textInputAction,
        inputFormatters: getFormatters,
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.gray100))),
      );
    }
    return TextField(
      onChanged: onChanged,
      maxLength: maxLength,
      controller: controller,
      keyboardType: textInputType,
      cursorColor: AppColors.white64,
      style: context.textTheme.displayLarge,
      textInputAction: textInputAction,
      inputFormatters: getFormatters,
      decoration: InputDecoration(
        hintText: getHint,
        hintStyle: hintStyle,
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.gray100)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.gray500)),
      ),
    );
  }
}

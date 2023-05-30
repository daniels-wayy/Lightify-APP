import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/widget/button/dialog_action_button.dart';
import 'package:lightify/core/ui/widget/helpers/no_connection_snackbar.dart';

class DialogUtil {
  static void showSnackBar(BuildContext context, SnackBar snackBar) =>
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

  static void closeSnackBar(BuildContext context) => ScaffoldMessenger.of(context).hideCurrentSnackBar();

  static void showNoConnectionSnackbar(BuildContext context) {
    try {
      showSnackBar(context, NoConnectionSnackbar(context: context, onDismiss: () => closeSnackBar(context)));
    } catch (e) {
      debugPrint('showNoConnectionSnackbar: $e');
    }
  }

  static Future<void> showToast(String msg) async {
    await Fluttertoast.showToast(
      msg: msg,
      timeInSecForIosWeb: 1,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.fullBlack,
      textColor: AppColors.gray300,
      fontSize: height(12),
    );
  }

  // static Future<T?> showAdaptiveAlertDialog<T>({
  //   required BuildContext context,
  //   String? title,
  //   Widget? content,
  //   String? negativeText,
  //   String? positiveText,
  // }) async {
  // showTextInputDialog(
  //   context: context,
  //   textFields: [DialogTextField()],
  // );
  // if (Platform.isIOS) {
  //   return await showCupertinoDialog(
  //       context: context,
  //       builder: (_) {
  //         return Theme(
  //           data: ThemeData.dark(),
  //           child: CupertinoAlertDialog(
  //             title: title == null
  //                 ? null
  //                 : Text(title, style: context.textTheme.titleSmall?.copyWith(letterSpacing: -0.35)),
  //             content: content,
  //             actions: _buildDialogActions(context, negativeText, positiveText),
  //           ),
  //         );
  //       });
  // }
  // return await showDialog(
  //     context: context,
  //     useSafeArea: true,
  //     builder: (_) {
  //       return AlertDialog(
  //         title:
  //             title == null ? null : Text(title, style: context.textTheme.titleSmall?.copyWith(letterSpacing: -0.35)),
  //         content: content,
  //         actions: _buildDialogActions(context, negativeText, positiveText),
  //         contentPadding: EdgeInsets.symmetric(horizontal: width(24)).copyWith(bottom: height(24), top: height(12)),
  //         titlePadding: EdgeInsets.symmetric(horizontal: width(24)).copyWith(top: height(32)),
  //         actionsPadding: EdgeInsets.symmetric(horizontal: width(24)).copyWith(bottom: height(24)),
  //         actionsAlignment: MainAxisAlignment.spaceBetween,
  //         backgroundColor: AppColors.fullBlack,
  //       );
  //     });
  // }

  // static List<Widget> _buildDialogActions(BuildContext context, String? negativeText, String? positiveText) {
  //   return [
  //     DialogActionButton(
  //         text: negativeText ?? AppConstants.strings.CANCEL, onTap: () => Navigator.of(context).pop(false)),
  //     DialogActionButton(text: positiveText ?? AppConstants.strings.OK, onTap: () => Navigator.of(context).pop(true)),
  //   ];
  // }
}

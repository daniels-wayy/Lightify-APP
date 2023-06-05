import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lightify/core/ui/styles/colors/app_colors.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
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
}

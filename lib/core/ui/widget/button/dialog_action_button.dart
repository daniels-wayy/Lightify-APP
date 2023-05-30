import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:lightify/core/ui/extensions/core_extensions.dart';
import 'package:lightify/core/ui/widget/common/bouncing_widget.dart';

class DialogActionButton extends StatelessWidget {
  const DialogActionButton({super.key, required this.text, this.onTap});

  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoDialogAction(onPressed: onTap, child: Text(text, style: context.textTheme.displayMedium));
    }
    return BouncingWidget(onTap: onTap, child: Text(text, style: context.textTheme.displayMedium));
  }
}

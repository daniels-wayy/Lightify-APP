import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPopScope extends StatelessWidget {
  const CustomPopScope({
    super.key,
    required this.child,
    required this.onWillPop,
  });

  final Widget child;
  final Future<bool> Function() onWillPop;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoPopScope(context);
    }

    if (Platform.isAndroid) {
      return _buildAndroidPopScope();
    }

    return _buildAndroidPopScope();
  }

  Widget _buildAndroidPopScope() {
    return WillPopScope(onWillPop: onWillPop, child: child);
  }

  Widget _buildCupertinoPopScope(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.localPosition.dy > MediaQuery.of(context).size.height / 2 && details.delta.dx >= 3) {
          onWillPop();
        }
      },
      child: child,
    );
  }
}

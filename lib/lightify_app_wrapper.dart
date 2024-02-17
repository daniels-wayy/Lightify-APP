import 'dart:io';

import 'package:flutter/material.dart';

class LightifyAppWrapper extends StatefulWidget {
  const LightifyAppWrapper({super.key, required this.appBody});

  final Widget appBody;

  @override
  State<LightifyAppWrapper> createState() => _LightifyAppWrapperState();
}

class _LightifyAppWrapperState extends State<LightifyAppWrapper> {
  AppLifecycleListener? _lifecycleListener;
  var _isAppInactive = Platform.isIOS;

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkAppLifecycleStatus());
      _lifecycleListener = AppLifecycleListener(onResume: _checkAppLifecycleStatus);
    }
  }

  @override
  void dispose() {
    _lifecycleListener?.dispose();
    super.dispose();
  }

  void _checkAppLifecycleStatus() {
    final state = WidgetsBinding.instance.lifecycleState;
    setState(() => _isAppInactive = state == AppLifecycleState.inactive);
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS && _isAppInactive) {
      return const SizedBox.shrink();
    }
    return widget.appBody;
  }
}

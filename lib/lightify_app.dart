import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightify/core/domain/repo/connectivity_repo.dart';
import 'package:lightify/core/ui/bloc/connectivity/connectivity_cubit.dart';
import 'package:lightify/core/ui/bloc/devices/devices_cubit.dart';
import 'package:lightify/core/ui/bloc/home_widgets_config/home_widgets_config_cubit.dart';
import 'package:lightify/core/ui/bloc/user_pref/user_pref_cubit.dart';
import 'package:lightify/core/ui/constants/app_constants.dart';
import 'package:lightify/core/ui/styles/text_styles/app_text_styles.dart';
import 'package:lightify/core/ui/styles/theme/app_theme.dart';
import 'package:lightify/core/ui/utils/screen_util.dart';
import 'package:lightify/core/ui/routes/root_routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lightify/di/di.dart';
import 'package:lightify/lightify_app_wrapper.dart';
import 'package:lightify/pages/main/home/ui/devices_watcher/devices_watcher_bloc.dart';

class LightifyApp extends StatefulWidget {
  const LightifyApp({super.key});

  @override
  State<LightifyApp> createState() => _LightifyAppState();
}

class _LightifyAppState extends State<LightifyApp> {
  @override
  void initState() {
    super.initState();
    _checkForRegistration();
  }

  void _checkForRegistration() {
    // check for registration
    if (!getIt.isRegistered<ConnectivityCubit>()) {
      getIt.registerFactory<ConnectivityCubit>(
        () => ConnectivityCubit(getIt<ConnectivityRepo>()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LightifyAppWrapper(appBody: LayoutBuilder(builder: (context, constraints) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<DevicesCubit>()),
          BlocProvider(create: (_) => getIt<UserPrefCubit>()),
          BlocProvider(create: (_) => getIt<ConnectivityCubit>()),
          BlocProvider(create: (_) => getIt<HomeWidgetsConfigCubit>()),
          BlocProvider(create: (_) => getIt<DevicesWatcherBloc>()),
        ],
        child: MaterialApp(
          title: AppConstants.strings.APP_TITLE,
          restorationScopeId: 'lightify_app',
          builder: (context, child) {
            final mediaQueryData = MediaQuery.of(context);
            final scale = mediaQueryData.textScaleFactor.clamp(
              AppTextStyles.textScaleFactorLowerLimit,
              AppTextStyles.textScaleFactorUpperLimit,
            );
            return OrientationBuilder(builder: (context, orientation) {
              final formattedConstraints = orientation == Orientation.portrait ? constraints : BoxConstraints(
                maxWidth: constraints.maxHeight,
                maxHeight: constraints.maxWidth,
                minHeight: constraints.minWidth,
                minWidth: constraints.minHeight,
              );

              ScreenUtil.init(formattedConstraints);
              ScreenUtil.initPaddings(mediaQueryData.padding);

              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
                child: child ??= const SizedBox.shrink(),
              );
            });
          },
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate, // This is required
          ],
          theme: AppTheme.fromType(ThemeType.light).themeData,
          onGenerateRoute: rootRouteFactory,
          initialRoute: Routes.MAIN,
        ),
      );
    }));
  }
}

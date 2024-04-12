part of 'app_theme.dart';

ThemeData get lightTheme {
  return ThemeData(
    useMaterial3: Platform.isAndroid,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: AppColors.primary100,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade200.withOpacity(0.1),
      space: 0.0,
      thickness: 1.0,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary100,
    ),
    scaffoldBackgroundColor: AppColors.white,
    // primaryColor: AppColors.white,
    primarySwatch: Colors.green,
    textTheme: TextTheme(
      displaySmall: AppTextStyles.displaySmall(),
      displayMedium: AppTextStyles.displayMedium(),
      displayLarge: AppTextStyles.displayLarge(),
      titleSmall: AppTextStyles.titleSmall(),
      titleMedium: AppTextStyles.titleMedium(),
      titleLarge: AppTextStyles.titleLarge(),
      bodySmall: AppTextStyles.bodySmall(),
      bodyMedium: AppTextStyles.bodyMedium(),
      bodyLarge: AppTextStyles.bodyLarge(),
      // labelMedium: AppTextStyles.labelMedium(),
      labelLarge: AppTextStyles.labelLarge(),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.white64,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    dialogBackgroundColor: AppColors.fullBlack,
    hintColor: AppColors.gray300.withOpacity(0.6),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: AppTextStyles.displayMedium().copyWith(color: AppColors.gray300.withOpacity(0.6)),
      focusColor: AppColors.white,
      border: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.white)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.white)),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.gray100)),
      counterStyle: AppTextStyles.displaySmall().copyWith(color: Colors.white70),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith((states) => AppColors.white08),
          foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
          shape: MaterialStateProperty.resolveWith(
              (states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
    ),
    dialogTheme: DialogTheme(
      surfaceTintColor: AppColors.white,
      iconColor: AppColors.white,
      backgroundColor: AppColors.fullBlack,
      titleTextStyle: AppTextStyles.titleSmall(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      contentTextStyle: AppTextStyles.displayMedium(),
      shadowColor: AppColors.gray100.withOpacity(0.4),
      actionsPadding: const EdgeInsets.only(bottom: 6.0, right: 8.0),
      elevation: 20.0,
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.white,
      textTheme: CupertinoTextThemeData(
        actionTextStyle: AppTextStyles.titleSmall(),
        textStyle: AppTextStyles.displayMedium(),
        primaryColor: AppColors.white,
      ), // This is required
    ),
    appBarTheme: AppBarTheme(surfaceTintColor: Platform.isIOS ? Colors.transparent : Colors.grey.shade800),
  );
}

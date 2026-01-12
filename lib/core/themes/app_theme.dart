// lib/core/themes/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // 颜色定义
  static const Color primaryColor = Colors.yellowAccent;
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFB00020);
  static const Color onPrimaryColor = Color(0xFF333333);
  static const Color onSecondaryColor = Color(0xFF000000);

  // 字体颜色
  static const Color textColorPrimary = Color(0xFF212121);
  static const Color textColorSecondary = Color(0xFF757575);
  static const Color textColorHint = Color(0xFF9E9E9E);

  // 文本样式定义
  static const TextStyle customAppBarTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: textColorPrimary,
  );

  // 文本样式定义
  static const TextStyle customHeadline1 = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w900,
    color: textColorPrimary,
  );

  static const TextStyle customHeadline2 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: textColorPrimary,
  );

  static const TextStyle customHeadline3 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: textColorPrimary,
  );

  static const TextStyle customHeadline4 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textColorPrimary,
  );

  static const TextStyle customHeadline5 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textColorPrimary,
  );

  static const TextStyle customHeadline6 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textColorPrimary,
  );

  static const TextStyle customSubtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textColorSecondary,
  );

  static const TextStyle customSubtitle2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textColorSecondary,
  );

  static const TextStyle customBodyText1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textColorPrimary,
  );

  static const TextStyle customBodyText2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textColorPrimary,
  );

  static const TextStyle customButtonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: onPrimaryColor,
  );

  static const TextStyle customCaption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textColorHint,
  );

  static const TextStyle customOverline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: textColorHint,
    letterSpacing: 1.5,
  );

  // 获取应用主题的方法
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white24,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onPrimaryColor,
        ),
      ),
      textTheme: const TextTheme(
        // 使用自定义样式覆盖默认样式
        displayLarge: customHeadline1,
        displayMedium: customHeadline2,
        displaySmall: customHeadline3,
        headlineMedium: customHeadline4,
        headlineSmall: customHeadline5,
        titleLarge: customHeadline6,
        titleMedium: customSubtitle1,
        titleSmall: customSubtitle2,
        bodyLarge: customBodyText1,
        bodyMedium: customBodyText2,
        labelLarge: customButtonText,
        bodySmall: customCaption,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onPrimaryColor,
          textStyle: customButtonText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: customButtonText.copyWith(color: primaryColor),
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  // 暗色主题（可选）
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      primaryColor: secondaryColor,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
        displaySmall: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Colors.grey,
        ),
      ),
    );
  }
}

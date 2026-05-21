import 'package:flutter/material.dart';
import 'package:portfolio_app/core/theme/site_style.dart';

class AppTheme {
  static ThemeData get site => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: SiteColors.bg,
        colorScheme: const ColorScheme.dark(
          primary: SiteColors.accent,
          secondary: SiteColors.accent2,
          surface: SiteColors.surface,
          onSurface: SiteColors.text,
          outline: SiteColors.border,
        ),
        fontFamily: null,
        textTheme: const TextTheme(
          displaySmall: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            height: 1.15,
            letterSpacing: -0.5,
            color: SiteColors.text,
          ),
          headlineSmall: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: SiteColors.text,
          ),
          titleMedium: TextStyle(fontSize: 17, color: SiteColors.text),
          bodyLarge: TextStyle(fontSize: 16, height: 1.7, color: SiteColors.text),
          bodyMedium: TextStyle(fontSize: 15, height: 1.7, color: SiteColors.textMuted),
          bodySmall: TextStyle(fontSize: 14, color: SiteColors.textMuted),
          labelMedium: TextStyle(
            fontSize: 14,
            fontFamily: 'monospace',
            color: SiteColors.accent,
            fontWeight: FontWeight.w500,
          ),
        ),
        appBarTheme: const AppBarTheme(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        cardTheme: CardTheme(
          color: SiteColors.surface,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SiteColors.radius),
            side: const BorderSide(color: SiteColors.border),
          ),
        ),
        dividerTheme: const DividerThemeData(color: SiteColors.border),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: SiteColors.bg,
          hintStyle: const TextStyle(color: SiteColors.textMuted),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: SiteColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: SiteColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: SiteColors.accent),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          tileColor: SiteColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(SiteColors.radius)),
            side: BorderSide(color: SiteColors.border),
          ),
        ),
      );
}

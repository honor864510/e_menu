import 'package:flutter/material.dart';

extension type AppThemeData._(ThemeData data) implements ThemeData {
  factory AppThemeData.lightTheme() => AppThemeData._(_$buildTheme(ThemeData.light()));

  factory AppThemeData.darkTheme() => AppThemeData._(_$buildTheme(ThemeData.dark()));
}

ThemeData _$buildTheme(ThemeData theme) {
  const borderSide = BorderSide(
    width: 1,
    color: Color.fromRGBO(0, 0, 0, 0.6),
    strokeAlign: BorderSide.strokeAlignInside,
  );

  const radius = BorderRadius.all(Radius.circular(8));

  return theme.copyWith(
    buttonTheme: theme.buttonTheme.copyWith(shape: const RoundedRectangleBorder(borderRadius: radius)),
    inputDecorationTheme: theme.inputDecorationTheme.copyWith(
      isCollapsed: false,
      isDense: false,
      filled: true,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
      border: const OutlineInputBorder(borderRadius: radius, borderSide: borderSide),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: borderSide.copyWith(color: theme.colorScheme.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: borderSide.copyWith(color: theme.colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: borderSide.copyWith(color: theme.colorScheme.error),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: borderSide.copyWith(color: const Color.fromRGBO(0, 0, 0, 0.24)),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: borderSide.copyWith(color: const Color.fromRGBO(0, 0, 0, 0.24)),
      ),
      outlineBorder: borderSide,
    ),
  );
}

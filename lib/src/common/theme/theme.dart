import 'package:flutter/material.dart';

extension type AppThemeData._(ThemeData data) implements ThemeData {
  factory AppThemeData.lightTheme({Color? seed}) => AppThemeData._(_$buildTheme(ThemeData.light(), seed: seed));

  factory AppThemeData.darkTheme({Color? seed}) => AppThemeData._(_$buildTheme(ThemeData.dark(), seed: seed));
}

ThemeData _$buildTheme(ThemeData theme, {Color? seed}) {
  const borderSide = BorderSide(
    width: 1,
    color: Color.fromRGBO(0, 0, 0, 0.6),
    strokeAlign: BorderSide.strokeAlignInside,
  );

  const radius = BorderRadius.all(Radius.circular(8));

  final colorScheme = ColorScheme.fromSeed(seedColor: seed ?? theme.colorScheme.primary);

  return theme.copyWith(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    textTheme: theme.textTheme.copyWith(
      titleLarge: theme.textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
      titleMedium: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
      titleSmall: theme.textTheme.titleSmall?.copyWith(color: colorScheme.onSurface),
      bodyLarge: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
      bodyMedium: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
      bodySmall: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
      displayLarge: theme.textTheme.displayLarge?.copyWith(color: colorScheme.onSurface),
      displayMedium: theme.textTheme.displayMedium?.copyWith(color: colorScheme.onSurface),
      displaySmall: theme.textTheme.displaySmall?.copyWith(color: colorScheme.onSurface),
      labelLarge: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
      labelMedium: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onSurface),
      labelSmall: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurface),
      headlineLarge: theme.textTheme.headlineLarge?.copyWith(color: colorScheme.onSurface),
      headlineMedium: theme.textTheme.headlineMedium?.copyWith(color: colorScheme.onSurface),
      headlineSmall: theme.textTheme.headlineSmall?.copyWith(color: colorScheme.onSurface),
    ),
    iconTheme: IconThemeData(color: colorScheme.onSurface),
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

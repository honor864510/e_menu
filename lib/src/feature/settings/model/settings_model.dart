import 'package:flutter/material.dart';

@immutable
final class SettingsModel {
  const SettingsModel({
    required this.name,
    required this.directusUrl,
    required this.seedColor,
    required this.servicePercentage,
    this.themeMode = ThemeMode.system,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
    name: json['name'] as String,
    directusUrl: json['directusUrl'] as String,
    seedColor: Color(json['colorPalette'] as int),
    servicePercentage: json['servicePercentage'] as double,
    themeMode: _parseThemeMode(json['themeMode'] as String?),
  );

  SettingsModel copyWith({
    String? name,
    String? directusUrl,
    Color? seedColor,
    double? servicePercentage,
    ThemeMode? themeMode,
  }) => SettingsModel(
    name: name ?? this.name,
    directusUrl: directusUrl ?? this.directusUrl,
    seedColor: seedColor ?? this.seedColor,
    servicePercentage: servicePercentage ?? this.servicePercentage,
    themeMode: themeMode ?? this.themeMode,
  );

  static const prefsKey = 'settings';

  final String name;
  final String directusUrl;
  final Color seedColor; // Theme color
  final double servicePercentage;
  final ThemeMode themeMode;

  Map<String, dynamic> toJson() => {
    'name': name,
    'directusUrl': directusUrl,
    'colorPalette': seedColor.toARGB32(),
    'servicePercentage': servicePercentage,
    'themeMode': _themeModeToString(themeMode),
  };

  static ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsModel &&
        other.name == name &&
        other.directusUrl == directusUrl &&
        other.seedColor == seedColor &&
        other.servicePercentage == servicePercentage &&
        other.themeMode == themeMode;
  }

  @override
  int get hashCode => Object.hashAll([name, directusUrl, seedColor, servicePercentage, themeMode]);
}

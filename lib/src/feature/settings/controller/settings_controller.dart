import 'dart:convert';

import 'package:e_menu/src/feature/settings/model/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController with ChangeNotifier {
  SettingsController({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;
  late SettingsModel _settings;

  SettingsModel get settings => _settings;

  /// Loads settings from SharedPreferences
  Future<void> loadSettings() async {
    final settingsJson = sharedPreferences.getString(SettingsModel.prefsKey);

    if (settingsJson != null) {
      final decodedJson = jsonDecode(settingsJson) as Map<String, dynamic>;
      _settings = SettingsModel.fromJson(decodedJson);
    } else {
      _settings = _defaultSettings;
    }

    notifyListeners();
  }

  SettingsModel get _defaultSettings => const SettingsModel(
    name: '',
    directusUrl: '',
    seedColor: Colors.indigo,
    servicePercentage: 0,
    themeMode: ThemeMode.system,
  );

  /// Saves current settings to SharedPreferences
  Future<void> saveSettings() async {
    final settingsJson = jsonEncode(_settings.toJson());
    await sharedPreferences.setString(SettingsModel.prefsKey, settingsJson);
  }

  /// Updates settings with new values
  Future<void> updateSettings(SettingsModel newSettings) async {
    _settings = newSettings;
    notifyListeners();
  }

  /// Updates a specific setting
  Future<void> updateSetting({
    String? name,
    String? directusUrl,
    Color? colorPalette,
    double? servicePercentage,
    ThemeMode? themeMode,
  }) async {
    _settings = _settings.copyWith(
      name: name,
      directusUrl: directusUrl,
      seedColor: colorPalette,
      servicePercentage: servicePercentage,
      themeMode: themeMode,
    );

    notifyListeners();
    await saveSettings();
  }

  /// Updates the theme mode
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    await updateSetting(themeMode: themeMode);
  }

  /// Resets settings to default values
  Future<void> resetToDefaults() async {
    _settings = _defaultSettings;
    notifyListeners();
    await saveSettings();
  }
}

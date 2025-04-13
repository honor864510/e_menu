import 'package:e_menu/src/common/model/dependencies.dart';
import 'package:e_menu/src/common/theme/theme.dart';
import 'package:e_menu/src/feature/menu/widget/meals_screen.dart';
import 'package:e_menu/src/feature/settings/widget/settings_screen.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Key builderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final settingsController = Dependencies.of(context).settingsController;
    final isFirstRun = settingsController.settings.name == '';

    return ListenableBuilder(
      listenable: settingsController,
      builder: (context, _) {
        final themeMode = settingsController.settings.themeMode;
        final seedColor = settingsController.settings.seedColor;

        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // Theme
          themeMode: themeMode,
          theme: AppThemeData.lightTheme(seed: seedColor),
          darkTheme: AppThemeData.darkTheme(seed: seedColor),

          // Home screen
          home: isFirstRun ? const SettingsScreen() : const MealsScreen(),

          // Builder
          builder:
              (context, child) => MediaQuery(
                key: builderKey,
                data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
                child: child ?? const SizedBox.shrink(),
              ),
        );
      },
    );
  }
}

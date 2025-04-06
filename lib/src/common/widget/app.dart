import 'package:e_menu/src/common/theme/theme.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Key builderKey = GlobalKey();

  @override
  Widget build(BuildContext context) => MaterialApp(
    // Theme
    theme: AppThemeData.lightTheme(),
    darkTheme: AppThemeData.darkTheme(),

    // Builder
    builder:
        (context, child) => MediaQuery(
          key: builderKey,
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: child ?? const SizedBox.shrink(),
        ),
  );
}

import 'package:e_menu/src/common/app_router/routes.dart';
import 'package:e_menu/src/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Key builderKey = GlobalKey();
  final router = Octopus(routes: Routes.values, defaultRoute: Routes.home);

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    // Theme
    theme: AppThemeData.lightTheme(),
    darkTheme: AppThemeData.darkTheme(),

    // Router
    routerConfig: router.config,

    // Builder
    builder:
        (context, child) => MediaQuery(
          key: builderKey,
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: OctopusTools(enable: true, octopus: router, child: child ?? const SizedBox.shrink()),
        ),
  );
}

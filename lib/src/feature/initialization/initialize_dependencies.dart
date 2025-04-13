import 'dart:async';

import 'package:e_menu/src/common/directus_client/directus_client.dart';
import 'package:e_menu/src/common/model/app_metadata.dart';
import 'package:e_menu/src/common/model/dependencies.dart';
import 'package:e_menu/src/common/util/logger.dart';
import 'package:e_menu/src/common/util/screen_util.dart';
import 'package:e_menu/src/constants/pubspec.yaml.g.dart';
import 'package:e_menu/src/feature/cart/controller/cart_controller.dart';
import 'package:e_menu/src/feature/cart/data/cart_repository.dart';
import 'package:e_menu/src/feature/menu/controller/meal_menu_controller.dart';
import 'package:e_menu/src/feature/menu/repository/meal_category_repository.dart';
import 'package:e_menu/src/feature/menu/repository/meal_repository.dart';
import 'package:e_menu/src/feature/settings/controller/settings_controller.dart';
import 'package:flutter/services.dart';
import 'package:platform_info/platform_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Initializes the app and returns a [Dependencies] object
Future<Dependencies> $initializeDependencies({void Function(int progress, String message)? onProgress}) async {
  final dependencies = Dependencies();
  final totalSteps = _initializationSteps.length;
  var currentStep = 0;
  for (final step in _initializationSteps.entries) {
    try {
      currentStep++;
      final percent = (currentStep * 100 ~/ totalSteps).clamp(0, 100);
      onProgress?.call(percent, step.key);
      logger.info('Initialization | $currentStep/$totalSteps ($percent%) | "${step.key}"');
      await step.value(dependencies);
    } on Object catch (error, stackTrace) {
      logger.error('Initialization failed at step "${step.key}": $error', error, stackTrace);
      Error.throwWithStackTrace('Initialization failed at step "${step.key}": $error', stackTrace);
    }
  }
  return dependencies;
}

typedef _InitializationStep = FutureOr<void> Function(Dependencies dependencies);
final Map<String, _InitializationStep> _initializationSteps = <String, _InitializationStep>{
  'Platform pre-initialization': (_) async {
    // Set the app to be full-screen (no buttons, bar or notifications on top).
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Set the preferred orientation of the app to landscape only.
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  },
  'Creating app metadata':
      (dependencies) =>
          dependencies.metadata = AppMetadata(
            isWeb: platform.js,
            isRelease: platform.buildMode.release,
            appName: Pubspec.name,
            appVersion: Pubspec.version.representation,
            appVersionMajor: Pubspec.version.major,
            appVersionMinor: Pubspec.version.minor,
            appVersionPatch: Pubspec.version.patch,
            appBuildTimestamp:
                Pubspec.version.build.isNotEmpty ? (int.tryParse(Pubspec.version.build.firstOrNull ?? '-1') ?? -1) : -1,
            operatingSystem: platform.operatingSystem.name,
            processorsCount: platform.numberOfProcessors,
            appLaunchedTimestamp: DateTime.now(),
            locale: platform.locale,
            deviceVersion: platform.version,
            deviceScreenSize: ScreenUtil.screenSize().representation,
          ),
  'Initializing analytics': (_) {},
  'Log app open': (_) {},
  'Get remote config': (_) {},
  'Restore settings': (_) {},
  'Initialize shared preferences':
      (dependencies) async => dependencies.sharedPreferences = await SharedPreferences.getInstance(),
  'SettingsController':
      (dependencies) =>
          dependencies.settingsController = SettingsController(sharedPreferences: dependencies.sharedPreferences)
            ..loadSettings(),
  'Connect to database': (_) => {},
  'Shrink database': (_) => {},
  'Migrate app from previous version': (_) => {},
  'API Client': (dependencies) => dependencies.directusClient = DirectusClient(),
  'Initialize repositories': (dependencies) {
    dependencies
      ..mealRepository = MealRepository(dependencies.directusClient)
      ..mealCategoryRepository = MealCategoryRepository(dependencies.directusClient)
      ..cartRepository = CartRepository(dependencies.sharedPreferences);
  },
  'Initialize Controllers':
      (dependencies) =>
          dependencies
            ..mealMenuController = MealMenuController(
              mealRepository: dependencies.mealRepository,
              categoryRepository: dependencies.mealCategoryRepository,
            )
            ..cartController = CartController(dependencies.cartRepository),
  'Initialize localization': (_) {},
  'Log app initialized': (_) {},
};

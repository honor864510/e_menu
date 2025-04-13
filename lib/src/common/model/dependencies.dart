import 'package:e_menu/src/common/directus_client/directus_client.dart';
import 'package:e_menu/src/common/model/app_metadata.dart';
import 'package:e_menu/src/feature/cart/controller/cart_controller.dart';
import 'package:e_menu/src/feature/cart/data/cart_repository.dart';
import 'package:e_menu/src/feature/menu/controller/meal_menu_controller.dart';
import 'package:e_menu/src/feature/menu/repository/meal_category_repository.dart';
import 'package:e_menu/src/feature/menu/repository/meal_repository.dart';
import 'package:e_menu/src/feature/settings/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template dependencies}
/// Application dependencies.
/// {@endtemplate}
class Dependencies {
  /// {@macro dependencies}
  Dependencies();

  /// The state from the closest instance of this class.
  ///
  /// {@macro dependencies}
  factory Dependencies.of(BuildContext context) => InheritedDependencies.of(context);

  /// Injest dependencies to the widget tree.
  Widget inject({required Widget child, Key? key}) => InheritedDependencies(dependencies: this, key: key, child: child);

  /// Shared preferences
  late final SharedPreferences sharedPreferences;

  /// App metadata
  late final AppMetadata metadata;

  /// Directus
  late final DirectusClient directusClient;

  /// Meal repository
  late final MealRepository mealRepository;

  /// Meal Category repository
  late final MealCategoryRepository mealCategoryRepository;

  /// Meal Category repository
  late final CartRepository cartRepository;

  /// Meal menu controller
  late final MealMenuController mealMenuController;

  /// Cart controller
  late final CartController cartController;

  /// SettingsController
  late final SettingsController settingsController;
}

/// {@template inherited_dependencies}
/// InheritedDependencies widget.
/// {@endtemplate}
class InheritedDependencies extends InheritedWidget {
  /// {@macro inherited_dependencies}
  const InheritedDependencies({required this.dependencies, required super.child, super.key});

  final Dependencies dependencies;

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  static Dependencies? maybeOf(BuildContext context) =>
      (context.getElementForInheritedWidgetOfExactType<InheritedDependencies>()?.widget as InheritedDependencies?)
          ?.dependencies;

  static Never _notFoundInheritedWidgetOfExactType() =>
      throw ArgumentError(
        'Out of scope, not found inherited widget '
            'a InheritedDependencies of the exact type',
        'out_of_scope',
      );

  /// The state from the closest instance of this class
  /// that encloses the given context.
  static Dependencies of(BuildContext context) => maybeOf(context) ?? _notFoundInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(covariant InheritedDependencies oldWidget) => false;
}

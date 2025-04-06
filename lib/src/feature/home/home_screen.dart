import 'package:e_menu/src/common/model/dependencies.dart';
import 'package:e_menu/src/common/widget/controller_scope.dart';
import 'package:e_menu/src/common/widget/scope_nester.dart';
import 'package:e_menu/src/feature/menu/controller/meal_category_controller.dart';
import 'package:e_menu/src/feature/menu/controller/meal_controller.dart';
import 'package:flutter/material.dart';

part '__screen.dart';

/// {@template home_screen}
/// HomeScreen widget.
/// {@endtemplate}
class HomeScreen extends StatelessWidget {
  /// {@macro home_screen}
  const HomeScreen({
    super.key, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) => ScopeNester(
    scopes: [
      (child) => ControllerScope(controller: MealController(Dependencies.of(context).mealRepository), child: child),
      (child) => ControllerScope(
        controller: MealCategoryController(Dependencies.of(context).mealCategoryRepository),
        child: child,
      ),
    ],
    child: _Screen(),
  );
}

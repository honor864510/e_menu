import 'package:e_menu/src/common/model/dependencies.dart';
import 'package:e_menu/src/common/widget/controller_scope.dart';
import 'package:e_menu/src/feature/menu/controller/meal_menu_controller.dart';
import 'package:e_menu/src/feature/menu/widget/basket_tab.dart';
import 'package:e_menu/src/feature/menu/widget/catalog_tab.dart';
import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';

part '__meal_menu_screen.dart';

/// {@template menu_screen}
/// MealMenuScreen widget.
/// {@endtemplate}
class MealMenuScreen extends StatelessWidget {
  /// {@macro menu_screen}
  const MealMenuScreen({
    super.key, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) {
    final dependencies = Dependencies.of(context);
    final mealRepository = dependencies.mealRepository;
    final mealCategoryRepository = dependencies.mealCategoryRepository;

    return ControllerScope(
      controller: MealMenuController(mealRepository: mealRepository, categoryRepository: mealCategoryRepository),
      child: _MealMenuScreen(),
    );
  }
}

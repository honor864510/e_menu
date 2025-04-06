import 'package:e_menu/src/common/model/dependencies.dart';
import 'package:e_menu/src/common/widget/controller_scope.dart';
import 'package:e_menu/src/feature/menu/controller/meal_menu_controller.dart';
import 'package:e_menu/src/feature/menu/widget/meal_menu_scope.dart';
import 'package:flutter/widgets.dart';

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
      child: MealMenuScope(child: _Screen()),
    );
  }
}

class _Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Placeholder();
}

import 'package:e_menu/src/common/model/dependencies.dart';
import 'package:e_menu/src/common/widget/controller_scope.dart';
import 'package:e_menu/src/common/widget/scope_nester.dart';
import 'package:e_menu/src/feature/menu/controller/meal_category_controller.dart';
import 'package:e_menu/src/feature/menu/controller/meal_menu_controller.dart';
import 'package:flutter/widgets.dart';

/// {@template meals_screen}
/// MealsScreen widget.
/// {@endtemplate}
class MealsScreen extends StatelessWidget {
  /// {@macro meals_screen}
  const MealsScreen({
    super.key, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) => ScopeNester(
    scopes: [
      (child) => ControllerScope(
        controller: MealMenuController(
          categoryRepository: Dependencies.of(context).mealCategoryRepository,
          mealRepository: Dependencies.of(context).mealRepository,
        ),
        child: child,
      ),
      (child) => ControllerScope(
        controller: MealCategoryController(Dependencies.of(context).mealCategoryRepository),
        child: child,
      ),
    ],
    child: _Screen(),
  );
}

class _Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Placeholder();
}

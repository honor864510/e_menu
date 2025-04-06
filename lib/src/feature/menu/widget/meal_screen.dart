import 'package:e_menu/src/common/widget/controller_scope.dart';
import 'package:e_menu/src/common/widget/not_found_screen.dart';
import 'package:e_menu/src/feature/menu/controller/meal_menu_controller.dart';
import 'package:flutter/material.dart';

/// {@template meal_screen}
/// MealScreen widget.
/// {@endtemplate}
class MealScreen extends StatelessWidget {
  /// {@macro meal_screen}
  const MealScreen({super.key, this.id});

  final Object? id;

  @override
  Widget build(BuildContext context) {
    const notFoundScreen = NotFoundScreen(message: 'Meal is not found');

    if (id == null || id is! String) return notFoundScreen;

    return FutureBuilder(
      future: ControllerScope.of<MealMenuController>(context).getMealById(id as String),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return const Center(child: CircularProgressIndicator());
        }

        final meal = snapshot.data;

        if (meal == null) {
          return notFoundScreen;
        }

        return Scaffold(
          bottomNavigationBar: Card(
            child: Row(
              children: [
                Text(
                  'Price: \$${meal.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(meal.directusImageUrl(context), height: 200, width: double.infinity, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meal.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

                    Text(meal.description, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:collection/collection.dart';
import 'package:e_menu/src/common/model/dependencies.dart';
import 'package:e_menu/src/common/widget/not_found_screen.dart';
import 'package:e_menu/src/feature/menu/model/meal_model.dart';
import 'package:flutter/material.dart';

/// {@template meal_screen}
/// MealScreen widget.
/// {@endtemplate}
class MealScreen extends StatelessWidget {
  /// {@macro meal_screen}
  const MealScreen({
    super.key,
    this.id, // ignore: unused_element
  });

  final Object? id;

  @override
  Widget build(BuildContext context) {
    const notFoundScreen = NotFoundScreen(message: 'Meal not found');

    if (id == null || id is! String) {
      return notFoundScreen;
    }

    final cartController = Dependencies.of(context).cartController;

    return FutureBuilder(
      future: Dependencies.of(context).mealMenuController.fetchMealById(id as String),
      builder: (context, snapshot) {
        final meal = snapshot.data;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError || meal == null) {
          return notFoundScreen;
        }

        return Scaffold(
          body: ListView(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(meal.directusImageUrl(context), fit: BoxFit.cover),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                        onPressed: () => Navigator.of(context).maybePop(),
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meal.name, style: TextTheme.of(context).headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Text(meal.description, style: TextTheme.of(context).bodyLarge),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: ListenableBuilder(
                      listenable: cartController,
                      builder:
                          (context, _) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${meal.price.toStringAsFixed(2)} TMT',
                                textAlign: TextAlign.center,
                                style: TextTheme.of(context).bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Итого: ${cartController.totalPrice.toStringAsFixed(2)} TMT',
                                textAlign: TextAlign.center,
                                style: TextTheme.of(context).bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 120, minHeight: 60),
                    child: _AddToCartBtns(meal: meal),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AddToCartBtns extends StatelessWidget {
  const _AddToCartBtns({required this.meal});

  final MealModel meal;

  @override
  Widget build(BuildContext context) {
    final cartController = Dependencies.of(context).cartController;

    return ListenableBuilder(
      listenable: cartController,
      builder: (context, _) {
        final cartItems = cartController.items;
        final cartItem = cartItems.firstWhereOrNull((element) => element.meal.id == meal.id);

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child:
              cartItem != null
                  ? Row(
                    key: const ValueKey('quantity_controls'),
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          cartController.updateQuantity(meal, cartItem.quantity - 1);
                        },
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 40),
                        child: Text(
                          '${cartItem.quantity}',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          cartController.updateQuantity(meal, cartItem.quantity + 1);
                        },
                      ),
                    ],
                  )
                  : FilledButton(
                    key: const ValueKey('add_button'),
                    onPressed: () => cartController.addToCart(meal),
                    style: FilledButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.all(20),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.add_shopping_cart),
                  ),
        );
      },
    );
  }
}

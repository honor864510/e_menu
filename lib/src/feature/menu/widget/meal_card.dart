import 'package:e_menu/src/common/model/dependencies.dart';
import 'package:e_menu/src/feature/menu/model/meal_model.dart';
import 'package:flutter/material.dart';

class MealCard extends StatelessWidget {
  const MealCard({required this.meal, super.key, this.onTap});

  final MealModel meal;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 2,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: InkWell(
      onTap: meal.available ? onTap : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Meal image with availability badge
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  meal.directusImageUrl(context),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image_not_supported, size: 48)),
                ),
                if (!meal.available)
                  Align(
                    alignment: Alignment.topRight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          'Out of Stock',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              meal.name,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              '${meal.price.toStringAsFixed(2)} TMT',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (meal.gr == 0)
                  const Spacer()
                else
                  Text(
                    '${meal.gr.toStringAsFixed(2)} gr',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ListenableBuilder(
                  listenable: Dependencies.of(context).cartController,
                  builder: (context, _) {
                    final controller = Dependencies.of(context).cartController;
                    final isAddedToCart = controller.containsMeal(meal);
                    final quantityInCart = controller.quantityOf(meal);

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedSwitcher(
                          duration: Durations.medium1,
                          child:
                              isAddedToCart
                                  ? FilledButton(
                                    key: ValueKey('DECREMENT_BTN_$meal'),
                                    onPressed: () => controller.decrementQuantity(meal),
                                    style: FilledButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: const EdgeInsets.all(14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: Icon(Icons.remove, color: Theme.of(context).colorScheme.onPrimary),
                                  )
                                  : const SizedBox(width: 30),
                        ),
                        SizedBox(
                          width: 30,
                          child: AnimatedSwitcher(
                            duration: Durations.medium1,
                            child:
                                isAddedToCart
                                    ? Text(
                                      '$quantityInCart',
                                      style: TextTheme.of(context).labelLarge,
                                      key: ValueKey('QUANTITY_IN_CART_$meal'),
                                    )
                                    : const SizedBox.shrink(),
                          ),
                        ),
                        FilledButton(
                          onPressed: meal.available ? () => controller.addToCart(meal) : null,
                          style: FilledButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.all(14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

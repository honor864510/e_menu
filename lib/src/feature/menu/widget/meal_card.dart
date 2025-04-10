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

          // Add to cart button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${meal.price.toStringAsFixed(2)} TMT',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                ListenableBuilder(
                  listenable: Dependencies.of(context).cartController,
                  builder: (context, _) {
                    final controller = Dependencies.of(context).cartController;

                    return FilledButton(
                      onPressed: meal.available ? () => controller.addToCart(meal) : null,
                      style: FilledButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
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

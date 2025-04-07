import 'package:e_menu/src/feature/menu/model/meal_model.dart';
import 'package:flutter/material.dart';

class MealCard extends StatelessWidget {
  const MealCard({required this.meal, super.key, this.onTap});

  final MealModel meal;

  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: meal.available ? 1 : 0.5,
    child: Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            // Meal image
            Expanded(
              flex: 3,
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    meal.directusImageUrl(context),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image_not_supported, size: 48)),
                  ),
                ),
              ),
            ),
            // Meal details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      meal.description,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${meal.price.toStringAsFixed(2)} TMT',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed:
                              meal.available
                                  ? () {
                                    // TODO: Add to cart functionality
                                  }
                                  : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

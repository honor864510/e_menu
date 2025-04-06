import 'package:e_menu/src/common/model/dependencies.dart';
import 'package:e_menu/src/feature/menu/model/meal_model.dart';
import 'package:flutter/material.dart';

class MealCard extends StatelessWidget {
  const MealCard({required this.meal, super.key});

  final MealModel meal;

  @override
  Widget build(BuildContext context) {
    if (!meal.available) {
      return Container(
        color: Colors.black54,
        child: const Center(
          child: Text('Not Available', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );
    }

    return Card(
      elevation: 2,
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
                  '${Dependencies.of(context).directusClient.directusUrl}/assets/${meal.imageUrl}',
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
                        '\$${meal.price.toStringAsFixed(2)}',
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
    );
  }
}

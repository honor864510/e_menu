import 'package:e_menu/src/common/model/dependencies.dart';
import 'package:flutter/material.dart';

/// {@template cart_screen}
/// CartScreen widget.
/// {@endtemplate}
class CartScreen extends StatelessWidget {
  /// {@macro cart_screen}
  const CartScreen({
    super.key, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) {
    final cartController = Dependencies.of(context).cartController;

    return ListenableBuilder(
      listenable: cartController,
      builder: (context, _) {
        if (cartController.itemCount == 0) {
          return const Center(child: Text('Корзина пуста'));
        }

        return ListView.separated(
          itemCount: cartController.itemCount,
          separatorBuilder: (context, index) => const SizedBox(height: 5),
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final cartItem = cartController.items[index];

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    cartItem.meal.directusImageUrl(context),
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cartItem.meal.name, style: Theme.of(context).textTheme.titleMedium),
                      Text('Bahasy: ${cartItem.meal.price} TMT'),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => cartController.decrementQuantity(cartItem.meal),
                          icon: const Icon(Icons.remove),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 20),
                          child: Center(
                            child: Text('${cartItem.quantity}', style: Theme.of(context).textTheme.titleMedium),
                          ),
                        ),
                        IconButton(
                          onPressed: () => cartController.incrementQuantity(cartItem.meal),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}

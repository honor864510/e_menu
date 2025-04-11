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

    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: Card(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ListenableBuilder(
            listenable: cartController,
            builder:
                (context, _) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TODO add service %
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Услуга ${10}%', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          '${(cartController.totalPrice * 0.1).toStringAsFixed(2)} TMT',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Итого', style: Theme.of(context).textTheme.headlineSmall),
                        Text(
                          '${cartController.totalPrice.toStringAsFixed(2)} TMT',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ],
                ),
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: cartController,
        builder: (context, _) {
          if (cartController.itemCount == 0) {
            return const Center(child: Text('Корзина пуста'));
          }

          return ListView.separated(
            itemCount: cartController.items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 5),
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final cartItem = cartController.items[index];

              return Dismissible(
                key: ValueKey(cartItem.meal.id),
                onDismissed: (direction) => cartController.removeFromCart(cartItem.meal),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      height: 80,
                      child: Row(
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(cartItem.meal.name, style: Theme.of(context).textTheme.titleMedium),
                                Text(
                                  '${cartItem.meal.price} TMT',
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => cartController.decrementQuantity(cartItem.meal),
                                  icon: const Icon(Icons.remove),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text('${cartItem.quantity}', style: Theme.of(context).textTheme.titleLarge),
                                ),
                                IconButton(
                                  onPressed: () => cartController.incrementQuantity(cartItem.meal),
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

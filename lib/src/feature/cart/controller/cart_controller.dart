import 'package:collection/collection.dart';
import 'package:e_menu/src/feature/cart/data/cart_repository.dart';
import 'package:e_menu/src/feature/cart/model/cart_item_model.dart';
import 'package:e_menu/src/feature/menu/model/meal_model.dart';
import 'package:flutter/foundation.dart';

class CartController extends ChangeNotifier {
  CartController(this._cartRepository);

  final ICartRepository _cartRepository;
  List<CartItemModel> _items = [];
  bool _isLoading = false;

  List<CartItemModel> get items => _items;
  bool get isLoading => _isLoading;

  double get totalPrice => _items.fold(0, (sum, item) => sum + (item.meal.price * item.quantity));

  int get itemCount => _items.length;

  /// Checks if a meal is already in the cart
  bool containsMeal(MealModel meal) => _items.any((item) => item.meal.id == meal.id);

  int quantityOf(MealModel meal) {
    final item = _items.firstWhereOrNull((item) => item.meal.id == meal.id);
    return item?.quantity ?? 0;
  }

  Future<void> loadCart() async {
    _setLoading(true);
    try {
      _items = await _cartRepository.getCartItems();
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> addToCart(MealModel meal, {int quantity = 1}) async {
    _setLoading(true);
    try {
      final cartItem = CartItemModel(id: 'CartItem_${meal.id}', meal: meal, quantity: quantity);
      await _cartRepository.addToCart(cartItem);
      await _refreshCart();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> removeFromCart(MealModel meal) async {
    _setLoading(true);
    try {
      await _cartRepository.removeFromCart(meal);
      await _refreshCart();
    } finally {
      _setLoading(false);
    }
  }

  /// Increments the quantity of a meal in the cart by 1
  Future<void> incrementQuantity(MealModel meal) async {
    final existingItem = _items.firstWhere(
      (item) => item.meal.id == meal.id,
      orElse: () => CartItemModel(id: 'CartItem_${meal.id}', meal: meal, quantity: 0),
    );

    await updateQuantity(meal, existingItem.quantity + 1);
  }

  /// Decrements the quantity of a meal in the cart by 1
  /// If quantity becomes 0, the item is removed from the cart
  Future<void> decrementQuantity(MealModel meal) async {
    final existingItem = _items.firstWhere(
      (item) => item.meal.id == meal.id,
      orElse: () => CartItemModel(id: 'CartItem_${meal.id}', meal: meal, quantity: 0),
    );

    if (existingItem.quantity <= 1) {
      await removeFromCart(meal);
    } else {
      await updateQuantity(meal, existingItem.quantity - 1);
    }
  }

  Future<void> updateQuantity(MealModel meal, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(meal);
      return;
    }

    _setLoading(true);
    try {
      await _cartRepository.updateQuantity(meal, quantity);
      await _refreshCart();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> clearCart() async {
    _setLoading(true);
    try {
      await _cartRepository.clearCart();
      _items = [];
      await _refreshCart();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _refreshCart() async {
    _items = await _cartRepository.getCartItems();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

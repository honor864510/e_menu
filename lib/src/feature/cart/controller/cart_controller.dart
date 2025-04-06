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

  Future<void> loadCart() async {
    _setLoading(true);
    try {
      _items = await _cartRepository.getCartItems();
      notifyListeners();
    } finally {
      _setLoading(false);
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
      notifyListeners();
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

import 'dart:convert';

import 'package:e_menu/src/feature/cart/model/cart_item_model.dart';
import 'package:e_menu/src/feature/menu/model/meal_model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class ICartRepository {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addToCart(CartItemModel item);
  Future<void> removeFromCart(MealModel meal);
  Future<void> updateQuantity(MealModel meal, int quantity);
  Future<void> clearCart();
}

@immutable
class CartRepository implements ICartRepository {
  const CartRepository(this._prefs);

  static const String _cartKey = 'cart_items';
  final SharedPreferences _prefs;

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final cartJson = _prefs.getString(_cartKey);
    if (cartJson == null) return [];

    final decodedList = jsonDecode(cartJson) as List<dynamic>;

    return decodedList.whereType<Map<String, dynamic>>().map((e) => CartItemModel.fromJson(e)).toList();
  }

  @override
  Future<void> addToCart(CartItemModel item) async {
    final items = await getCartItems();
    final existingIndex = items.indexWhere((i) => i.meal.id == item.meal.id);

    if (existingIndex != -1) {
      items[existingIndex] = item.copyWith(quantity: items[existingIndex].quantity + item.quantity);
    } else {
      items.add(item);
    }

    await _saveCart(items);
  }

  @override
  Future<void> removeFromCart(MealModel meal) async {
    final items = await getCartItems();
    items.removeWhere((item) => item.meal.id == meal.id);
    await _saveCart(items);
  }

  @override
  Future<void> updateQuantity(MealModel meal, int quantity) async {
    final items = await getCartItems();
    final index = items.indexWhere((item) => item.meal.id == meal.id);

    if (index != -1) {
      items[index] = items[index].copyWith(quantity: quantity);
      await _saveCart(items);
    }
  }

  @override
  Future<void> clearCart() async {
    await _prefs.remove(_cartKey);
  }

  Future<void> _saveCart(List<CartItemModel> items) async {
    final encodedList = jsonEncode(items.map((e) => e.toJson()).toList());
    await _prefs.setString(_cartKey, encodedList);
  }
}

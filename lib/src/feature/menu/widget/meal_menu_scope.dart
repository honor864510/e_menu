import 'dart:collection';

import 'package:e_menu/src/common/widget/controller_scope.dart';
import 'package:e_menu/src/feature/menu/controller/meal_menu_controller.dart';
import 'package:e_menu/src/feature/menu/model/meal_category_model.dart';
import 'package:e_menu/src/feature/menu/model/meal_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// {@template meal_menu_scope}
/// MealMenuScope widget.
/// {@endtemplate}
class MealMenuScope extends StatefulWidget {
  /// {@macro meal_menu_scope}
  const MealMenuScope({required this.child, super.key});

  /// The widget below this widget in the tree.
  final Widget child;

  /// Refetch data.
  static void refetch(BuildContext context) => ControllerScope.of<MealMenuController>(context).fetch();

  /// Get list of root categories.
  static List<MealCategoryModel> getRootCategories(BuildContext context, {bool listen = true}) =>
      _InheritedCategories.getRootCategories(context, listen: listen);

  /// Get category content by id.
  static CategoryContent? getCategoryById(BuildContext context, MealCategoryID id, {bool listen = true}) =>
      _InheritedCategories.getById(context, id, listen: listen);

  /// Get product by id.
  static MealModel? getProductById(BuildContext context, MealID id, {bool listen = true}) =>
      _InheritedProducts.getById(context, id, listen: listen);

  /// Check if a meal is in favorites
  static bool isFavorite(BuildContext context, MealID id, {bool listen = true}) =>
      _InheritedFavorite.isFavorite(context, id, listen: listen);

  /// Get all favorite meal IDs
  static Set<MealID> getFavorites(BuildContext context, {bool listen = true}) =>
      _InheritedFavorite.getFavorites(context, listen: listen);

  @override
  State<MealMenuScope> createState() => _MealMenuScopeState();
}

/// State for widget MealMenuScope.
class _MealMenuScopeState extends State<MealMenuScope> {
  late final MealMenuController _menuController;
  List<MealCategoryModel> _categories = <MealCategoryModel>[];
  List<MealModel> _products = <MealModel>[];
  List<MealCategoryModel> _rootCategories = <MealCategoryModel>[];
  Map<MealCategoryID, CategoryContent> _tableCategories = <MealCategoryID, CategoryContent>{};
  Map<MealID, MealModel> _tableProduct = <MealID, MealModel>{};

  /* #region Lifecycle */
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _menuController = ControllerScope.of<MealMenuController>(context);
    _menuController.addListener(_onStateChanged);
    _onStateChanged();

    // Initial data fetch if needed
    if (_categories.isEmpty && _products.isEmpty) {
      _menuController.fetch();
    }
  }

  @override
  void dispose() {
    _menuController.removeListener(_onStateChanged);
    super.dispose();
  }
  /* #endregion */

  void _onStateChanged() {
    if (!mounted) return;

    final categoriesChanged = !identical(_categories, _menuController.categories);
    final productsChanged = !identical(_products, _menuController.meals);

    if (!categoriesChanged && !productsChanged) return;

    _categories = _menuController.categories;
    _products = _menuController.meals;
    _rootCategories = <MealCategoryModel>[];
    _tableCategories = <MealCategoryID, CategoryContent>{};
    _tableProduct = <MealID, MealModel>{};

    // Process categories
    for (final category in _categories) {
      _tableCategories[category.id] = CategoryContent._(category);
    }

    // Process products
    for (final product in _products) {
      _tableProduct[product.id] = product;
      final categoryId = product.category.id;
      _tableCategories[categoryId]?._products.add(product);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) => _InheritedCategories(
    root: _rootCategories,
    table: _tableCategories,
    child: _InheritedProducts(table: _tableProduct, child: widget.child),
  );
}

/// Category content.
@immutable
final class CategoryContent {
  CategoryContent._(this.category) : _categories = <MealCategoryModel>[], _products = <MealModel>[];

  /// Current category.
  final MealCategoryModel category;

  /// List of subcategories.
  final List<MealCategoryModel> _categories;
  late final List<MealCategoryModel> categories = UnmodifiableListView<MealCategoryModel>(_categories);

  /// List of products.
  final List<MealModel> _products;
  late final List<MealModel> products = UnmodifiableListView<MealModel>(_products);
}

class _InheritedCategories extends InheritedModel<MealCategoryID> {
  const _InheritedCategories({required this.root, required this.table, required super.child});

  /// List of root categories.
  final List<MealCategoryModel> root;

  /// Table of categories.
  final Map<MealCategoryID, CategoryContent> table;

  static _InheritedCategories? maybeOf(BuildContext context, {bool listen = true}) =>
      listen
          ? context.dependOnInheritedWidgetOfExactType<_InheritedCategories>()
          : context.getInheritedWidgetOfExactType<_InheritedCategories>();

  /// Get list of root categories.
  static List<MealCategoryModel> getRootCategories(BuildContext context, {bool listen = true}) =>
      (listen
              ? InheritedModel.inheritFrom<_InheritedCategories>(context, aspect: null)
              : maybeOf(context, listen: false))
          ?.root ??
      <MealCategoryModel>[];

  /// Get category content by id.
  static CategoryContent? getById(BuildContext context, MealCategoryID id, {bool listen = true}) =>
      (listen ? InheritedModel.inheritFrom<_InheritedCategories>(context, aspect: id) : maybeOf(context, listen: false))
          ?.table[id];

  @override
  bool updateShouldNotify(covariant _InheritedCategories oldWidget) =>
      !identical(root, oldWidget.root) || !identical(table, oldWidget.table);

  @override
  bool updateShouldNotifyDependent(covariant _InheritedCategories oldWidget, Set<MealCategoryID> aspects) {
    for (final id in aspects) {
      if (table[id]?.category != oldWidget.table[id]?.category) return true;
    }
    return false;
  }
}

class _InheritedProducts extends InheritedModel<MealID> {
  const _InheritedProducts({required this.table, required super.child});

  /// Table of products.
  final Map<MealID, MealModel> table;

  static _InheritedProducts? maybeOf(BuildContext context, {bool listen = true}) =>
      listen
          ? context.dependOnInheritedWidgetOfExactType<_InheritedProducts>()
          : context.getInheritedWidgetOfExactType<_InheritedProducts>();

  /// Get product by id.
  static MealModel? getById(BuildContext context, MealID id, {bool listen = true}) =>
      (listen ? InheritedModel.inheritFrom<_InheritedProducts>(context, aspect: id) : maybeOf(context, listen: false))
          ?.table[id];

  @override
  bool updateShouldNotify(covariant _InheritedProducts oldWidget) => !identical(table, oldWidget.table);

  @override
  bool updateShouldNotifyDependent(covariant _InheritedProducts oldWidget, Set<MealID> aspects) {
    for (final id in aspects) {
      if (table[id] != oldWidget.table[id]) return true;
    }
    return false;
  }
}

class _InheritedFavorite extends InheritedModel<MealID> {
  const _InheritedFavorite({required this.favorites, required super.child});

  final Set<MealID> favorites;

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  /// e.g. `_InheritedFavorite.maybeOf(context)`.
  static _InheritedFavorite? maybeOf(BuildContext context, {bool listen = true}) =>
      listen
          ? context.dependOnInheritedWidgetOfExactType<_InheritedFavorite>()
          : context.getInheritedWidgetOfExactType<_InheritedFavorite>();

  static Set<MealID> getFavorites(BuildContext context, {bool listen = true}) =>
      maybeOf(context, listen: listen)?.favorites ?? <MealID>{};

  static bool isFavorite(BuildContext context, MealID id, {bool listen = true}) =>
      (listen ? InheritedModel.inheritFrom<_InheritedFavorite>(context, aspect: id) : maybeOf(context, listen: false))
          ?.favorites
          .contains(id) ??
      false;

  @override
  bool updateShouldNotify(covariant _InheritedFavorite oldWidget) => !setEquals(favorites, oldWidget.favorites);

  @override
  bool updateShouldNotifyDependent(covariant _InheritedFavorite oldWidget, Set<MealID> aspects) {
    for (final id in aspects) {
      if (favorites.contains(id) != oldWidget.favorites.contains(id)) return true;
    }
    return false;
  }
}

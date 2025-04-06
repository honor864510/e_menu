import 'package:collection/collection.dart';
import 'package:e_menu/src/feature/menu/model/meal_category_model.dart';
import 'package:e_menu/src/feature/menu/model/meal_model.dart';
import 'package:e_menu/src/feature/menu/repository/meal_category_repository.dart';
import 'package:e_menu/src/feature/menu/repository/meal_repository.dart';
import 'package:flutter/foundation.dart';

typedef MealCategoryTable = Map<MealCategoryModel, List<MealModel>>;

/// Controller for managing both meals and meal categories
/// Uses [ChangeNotifier] to notify listeners of state changes
class MealMenuController extends ChangeNotifier {
  /// Creates a new [MealMenuController] with the required repositories
  MealMenuController({required IMealRepository mealRepository, required IMealCategoryRepository categoryRepository})
    : _mealRepository = mealRepository,
      _categoryRepository = categoryRepository;

  final IMealRepository _mealRepository;
  final IMealCategoryRepository _categoryRepository;

  // Meal state
  List<MealModel> _meals = [];

  // Category state
  List<MealCategoryModel> _categories = [];

  MealCategoryTable get mealCategoryTable {
    final table = <MealCategoryModel, List<MealModel>>{};

    for (final category in _categories) {
      table[category] = _meals.where((meal) => meal.categoryId == category.id).toList();
    }

    return table;
  }

  // Common state
  bool _isLoading = false;

  /// Gets the current loading state
  bool get isLoading => _isLoading;

  /// Fetches both meals and categories
  Future<void> fetch() async {
    _setLoading(true);

    try {
      // Fetch both in parallel
      final results = await Future.wait([_mealRepository.fetch(), _categoryRepository.fetch()]);

      _meals = results[0] as List<MealModel>;
      _categories = results[1] as List<MealCategoryModel>;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Gets a meal by its ID
  MealModel? getMealById(String id) => _meals.firstWhereOrNull((meal) => meal.id == id);

  /// Sets the loading state and notifies listeners
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Refreshes all menu data
  Future<void> refresh() => fetch();
}

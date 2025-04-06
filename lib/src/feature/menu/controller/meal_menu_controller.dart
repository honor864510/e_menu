import 'package:collection/collection.dart';
import 'package:e_menu/src/feature/menu/model/meal_category_model.dart';
import 'package:e_menu/src/feature/menu/model/meal_model.dart';
import 'package:e_menu/src/feature/menu/repository/meal_category_repository.dart';
import 'package:e_menu/src/feature/menu/repository/meal_repository.dart';
import 'package:flutter/foundation.dart';

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

  // Common state
  bool _isLoading = false;

  /// Gets the current list of meals
  List<MealModel> get meals => _meals;

  /// Gets the current list of meal categories
  List<MealCategoryModel> get categories => _categories;

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

      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Fetches only meals
  Future<void> fetchMeals() async {
    _setLoading(true);

    try {
      _meals = await _mealRepository.fetch();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Fetches only categories
  Future<void> fetchCategories() async {
    _setLoading(true);

    try {
      _categories = await _categoryRepository.fetch();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Gets meals by category ID
  List<MealModel> getMealsByCategory(String categoryId) =>
      _meals.where((meal) => meal.categoryId == categoryId).toList();

  /// Gets a meal by its ID
  MealModel? getMealById(String id) => _meals.firstWhereOrNull((meal) => meal.id == id);

  /// Gets a category by its ID
  MealCategoryModel? getCategoryById(String id) => _categories.firstWhereOrNull((category) => category.id == id);

  /// Sets the loading state and notifies listeners
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Refreshes all menu data
  Future<void> refresh() => fetch();
}

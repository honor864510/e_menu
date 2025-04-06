import 'package:collection/collection.dart';
import 'package:e_menu/src/feature/menu/model/meal_model.dart';
import 'package:e_menu/src/feature/menu/repository/meal_repository.dart';
import 'package:flutter/foundation.dart';

/// Controller for managing meals
/// Uses [ChangeNotifier] to notify listeners of state changes
class MealController extends ChangeNotifier {
  /// Creates a new [MealController] with the required repository
  MealController(this._repository);

  final IMealRepository _repository;

  /// List of meals
  List<MealModel> _meals = [];

  /// Loading state
  bool _isLoading = false;

  /// Error message if any
  String? _errorMessage;

  /// Gets the current list of meals
  List<MealModel> get meals => _meals;

  /// Gets the current loading state
  bool get isLoading => _isLoading;

  /// Gets the current error message
  String? get errorMessage => _errorMessage;

  /// Fetches meals from the repository
  Future<void> fetchMeals() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _meals = await _repository.fetch();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Gets meals by category ID
  List<MealModel> getMealsByCategory(String categoryId) =>
      _meals.where((meal) => meal.category.id == categoryId).toList();

  /// Gets a meal by its ID
  MealModel? getMealById(String id) => _meals.firstWhereOrNull((meal) => meal.id == id);

  /// Sets the loading state and notifies listeners
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Refreshes the meals list
  Future<void> refresh() => fetchMeals();
}

import 'package:e_menu/src/feature/menu/model/meal_category_model.dart';
import 'package:e_menu/src/feature/menu/repository/meal_category_repository.dart';
import 'package:flutter/foundation.dart';

/// Controller for managing meal categories
/// Uses [ChangeNotifier] to notify listeners of state changes
class MealCategoryController extends ChangeNotifier {
  /// Creates a new [MealCategoryController] with the required repository
  MealCategoryController(this._repository);

  final IMealCategoryRepository _repository;

  /// List of meal categories
  List<MealCategoryModel> _categories = [];

  /// Loading state
  bool _isLoading = false;

  /// Error message if any
  String? _errorMessage;

  /// Gets the current list of meal categories
  List<MealCategoryModel> get categories => _categories;

  /// Gets the current loading state
  bool get isLoading => _isLoading;

  /// Gets the current error message
  String? get errorMessage => _errorMessage;

  /// Fetches meal categories from the repository
  Future<void> fetchCategories() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _categories = await _repository.fetch();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Sets the loading state and notifies listeners
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Refreshes the categories list
  Future<void> refresh() => fetchCategories();
}

import 'package:e_menu/src/common/directus_client/directus_client.dart';
import 'package:e_menu/src/common/model/dependencies.dart';
import 'package:e_menu/src/feature/menu/model/meal_category_model.dart';
import 'package:flutter/material.dart';

/// Interface for meal category repository operations
abstract interface class IMealCategoryRepository {
  /// Fetches all meal categories from the data source
  Future<List<MealCategoryModel>> fetch(BuildContext context);
}

/// Implementation of [IMealCategoryRepository] using Directus as a data source
@immutable
class MealCategoryRepository implements IMealCategoryRepository {
  /// Creates a new [MealCategoryRepository] instance
  const MealCategoryRepository(this._directusClient);

  final DirectusClient _directusClient;

  @override
  Future<List<MealCategoryModel>> fetch(BuildContext context) async {
    final response = await _directusClient.dio.get<Map<String, dynamic>>(
      '${Dependencies.of(context).settingsController.settings.directusUrl}/items/${MealCategoryModel.collectionName}',
    );

    final data = (response.data?['data'] as List?)?.cast<Map<String, dynamic>>();
    if (data == null) {
      Error.throwWithStackTrace(Exception('Data is not valid'), StackTrace.current);
    }

    return data.map<MealCategoryModel>(MealCategoryModel.fromJson).toList();
  }
}

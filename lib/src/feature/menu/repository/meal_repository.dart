import 'package:e_menu/src/common/directus_client/directus_client.dart';
import 'package:e_menu/src/common/model/dependencies.dart';
import 'package:e_menu/src/feature/menu/model/meal_model.dart';
import 'package:flutter/material.dart';

/// Repository interface for managing meal-related operations
/// Provides methods to interact with meal data from a data source
abstract interface class IMealRepository {
  /// Retrieves a list of all available meals from the data source
  /// Returns a Future that resolves to a List of [MealModel] objects
  Future<List<MealModel>> fetch(BuildContext context);

  Future<List<MealModel>> fetchByCategory(String categoryId, {required BuildContext context});

  Future<MealModel> fetchById(String id, {required BuildContext context});
}

/// Concrete implementation of [IMealRepository] that uses Directus backend
/// Handles communication with Directus API for meal-related operations
@immutable
class MealRepository implements IMealRepository {
  /// Constructs a [MealRepository] with the required [DirectusClient]
  /// [_directusClient] is used for making HTTP requests to the Directus API
  const MealRepository(this._directusClient);

  final DirectusClient _directusClient;

  @override
  Future<List<MealModel>> fetch(BuildContext context) async {
    final response = await _directusClient.dio.get<Map<String, dynamic>>(
      '${Dependencies.of(context).settingsController.settings.directusUrl}/items/${MealModel.collectionName}',
      queryParameters: {'sort': '-available,name'},
    );

    final data = (response.data?['data'] as List?)?.cast<Map<String, dynamic>>();
    if (data == null) {
      Error.throwWithStackTrace(Exception('Data is not valid'), StackTrace.current);
    }

    return data.map<MealModel>(MealModel.fromJson).toList();
  }

  @override
  Future<List<MealModel>> fetchByCategory(String categoryId, {required BuildContext context}) async {
    final response = await _directusClient.dio.get<Map<String, dynamic>>(
      '${Dependencies.of(context).settingsController.settings.directusUrl}/items/${MealModel.collectionName}',
      queryParameters: {
        'filter': {
          'category': {'_eq': categoryId},
        },
        'sort': '-available,name',
      },
    );

    final data = (response.data?['data'] as List?)?.cast<Map<String, dynamic>>();
    if (data == null) {
      Error.throwWithStackTrace(Exception('Data is not valid'), StackTrace.current);
    }

    final meals = data.map<MealModel>(MealModel.fromJson).toList();

    return meals;
  }

  @override
  Future<MealModel> fetchById(String id, {required BuildContext context}) async {
    final response = await _directusClient.dio.get<Map<String, dynamic>>(
      '${Dependencies.of(context).settingsController.settings.directusUrl}/items/${MealModel.collectionName}/$id',
    );

    final data = response.data?['data'] as Map<String, dynamic>?;
    if (data == null) {
      Error.throwWithStackTrace(Exception('Meal not found'), StackTrace.current);
    }

    return MealModel.fromJson(data);
  }
}

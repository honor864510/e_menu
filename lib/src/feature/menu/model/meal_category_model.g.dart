// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealCategoryModel _$MealCategoryModelFromJson(Map<String, dynamic> json) =>
    MealCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$MealCategoryModelToJson(MealCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealModel _$MealModelFromJson(Map<String, dynamic> json) => MealModel(
  id: json['id'] as String,
  name: json['name'] as String? ?? '',
  description: json['description'] as String? ?? '',
  price: (json['price'] as num?)?.toDouble() ?? 0.0,
  gr: (json['gr'] as num?)?.toDouble() ?? 0.0,
  imageUrl: json['image'] as String? ?? '',
  imageUrls:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  categoryId: json['category'] as String?,
  available: json['available'] as bool? ?? true,
);

Map<String, dynamic> _$MealModelToJson(MealModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'gr': instance.gr,
  'image': instance.imageUrl,
  'images': instance.imageUrls,
  'category': instance.categoryId,
  'available': instance.available,
};

import 'package:e_menu/src/common/model/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meal_model.g.dart';

typedef MealID = String;

@JsonSerializable()
@immutable
class MealModel {
  const MealModel({
    required this.id,
    this.name = '',
    this.description = '',
    this.price = 0.0,
    this.gr = 0.0,
    this.imageUrl = '',
    this.imageUrls = const [],
    this.categoryId,
    this.available = true,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) => _$MealModelFromJson(json);

  @JsonKey(name: 'id')
  final MealID id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'price')
  final double price;

  @JsonKey(name: 'gr')
  final double gr;

  @JsonKey(name: 'image')
  final String imageUrl;

  @JsonKey(name: 'images')
  final List<String> imageUrls;

  @JsonKey(name: 'category')
  final String? categoryId;

  @JsonKey(name: 'available')
  final bool available;

  String directusImageUrl(BuildContext context) =>
      '${Dependencies.of(context).settingsController.settings.directusUrl}/assets/$imageUrl';

  Map<String, dynamic> toJson() => _$MealModelToJson(this);

  MealModel copyWith({
    MealID? id,
    String? name,
    String? description,
    double? price,
    double? gr,
    String? imageUrl,
    List<String>? imageUrls,
    String? categoryId,
    bool? available,
  }) => MealModel(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    price: price ?? this.price,
    gr: gr ?? this.gr,
    imageUrl: imageUrl ?? this.imageUrl,
    imageUrls: imageUrls ?? this.imageUrls,
    categoryId: categoryId ?? this.categoryId,
    available: available ?? this.available,
  );

  /// The Directus collection name
  static const String collectionName = 'meal';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MealModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.gr == gr &&
        other.imageUrl == imageUrl &&
        other.imageUrls == imageUrls &&
        other.categoryId == categoryId &&
        other.available == available;
  }

  @override
  int get hashCode => Object.hashAll([id, name, description, price, gr, imageUrl, imageUrls, categoryId, available]);
}

import 'package:e_menu/src/feature/menu/model/meal_category_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'meal_model.g.dart';

typedef MealID = String;

@JsonSerializable()
@immutable
class MealModel {
  const MealModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.category,
    this.available = true,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) => _$MealModelFromJson(json);

  final MealID id;
  final String name;
  final String description;
  final double price;
  final List<String> imageUrls;
  final MealCategoryModel category;
  final bool available;

  Map<String, dynamic> toJson() => _$MealModelToJson(this);

  MealModel copyWith({
    MealID? id,
    String? name,
    String? description,
    double? price,
    List<String>? imageUrls,
    MealCategoryModel? category,
    bool? available,
  }) => MealModel(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    price: price ?? this.price,
    imageUrls: imageUrls ?? this.imageUrls,
    category: category ?? this.category,
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
        other.imageUrls == imageUrls &&
        other.category == category &&
        other.available == available;
  }

  @override
  int get hashCode => Object.hashAll([id, name, description, price, imageUrls, category, available]);
}

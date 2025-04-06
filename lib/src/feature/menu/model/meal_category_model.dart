import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'meal_category_model.g.dart';

typedef MealCategoryID = String;

@JsonSerializable()
@immutable
class MealCategoryModel {
  const MealCategoryModel({required this.id, required this.name, this.description, this.imageUrl});

  factory MealCategoryModel.fromJson(Map<String, dynamic> json) => _$MealCategoryModelFromJson(json);

  final String id;
  final String name;
  final String? description;
  final String? imageUrl;

  Map<String, dynamic> toJson() => _$MealCategoryModelToJson(this);

  MealCategoryModel copyWith({String? id, String? name, String? description, String? imageUrl}) => MealCategoryModel(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    imageUrl: imageUrl ?? this.imageUrl,
  );

  /// The Directus collection name
  static const String collectionName = 'meal_category';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MealCategoryModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => Object.hashAll([id, name, description, imageUrl]);
}

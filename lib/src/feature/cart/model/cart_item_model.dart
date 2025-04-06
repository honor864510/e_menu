import 'package:e_menu/src/feature/menu/model/meal_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'cart_item_model.g.dart';

@JsonSerializable()
@immutable
class CartItemModel {
  const CartItemModel({required this.id, required this.meal, required this.quantity, this.note});

  factory CartItemModel.fromJson(Map<String, dynamic> json) => _$CartItemModelFromJson(json);

  final String id;
  final MealModel meal;
  final int quantity;
  final String? note;

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  CartItemModel copyWith({String? id, MealModel? meal, int? quantity, String? note}) => CartItemModel(
    id: id ?? this.id,
    meal: meal ?? this.meal,
    quantity: quantity ?? this.quantity,
    note: note ?? this.note,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItemModel &&
        other.id == id &&
        other.meal == meal &&
        other.quantity == quantity &&
        other.note == note;
  }

  @override
  int get hashCode => id.hashCode ^ meal.hashCode ^ quantity.hashCode ^ note.hashCode;
}

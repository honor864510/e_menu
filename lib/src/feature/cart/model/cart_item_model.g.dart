// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      id: json['id'] as String,
      meal: MealModel.fromJson(json['meal'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'meal': instance.meal,
      'quantity': instance.quantity,
      'note': instance.note,
    };

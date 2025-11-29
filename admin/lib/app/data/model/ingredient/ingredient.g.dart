// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) => Ingredient(
  id: json['id'] as String,
  name: json['name'] as String,
  stockUnit: $enumDecode(_$UnitsTypeEnumMap, json['stockUnit']),
  currentStock: json['currentStock'] as num,
  minimumStock: json['minimumStock'] as num?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'stockUnit': _$UnitsTypeEnumMap[instance.stockUnit]!,
      'currentStock': instance.currentStock,
      'minimumStock': instance.minimumStock,
    };

const _$UnitsTypeEnumMap = {
  UnitsType.gram: 'gram',
  UnitsType.liter: 'liter',
  UnitsType.packet: 'packet',
};

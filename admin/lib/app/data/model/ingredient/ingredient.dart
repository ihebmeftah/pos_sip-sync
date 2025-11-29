import 'package:admin/app/data/model/enums/units_type.dart';
import 'package:json_annotation/json_annotation.dart';
part 'ingredient.g.dart';
@JsonSerializable()
class Ingredient {
  @JsonKey(includeToJson: false)
  String id;
  String name;
  String? description;
  UnitsType stockUnit;
  num currentStock;
  num? minimumStock;

  Ingredient({
    required this.id,
    required this.name,
    required this.stockUnit,
    required this.currentStock,
    this.minimumStock,
    this.description,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);
}

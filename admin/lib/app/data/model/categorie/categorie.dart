import 'package:json_annotation/json_annotation.dart';
part 'categorie.g.dart';

@JsonSerializable()
class Categorie {
  String id;
  String name;
  String? description;
  String? image;

  Categorie({
    required this.id,
    required this.name,
    this.description,
    this.image,
  });

  factory Categorie.fromJson(Map<String, dynamic> json) =>
      _$CategorieFromJson(json);
  Map<String, dynamic> toJson() => _$CategorieToJson(this);
}

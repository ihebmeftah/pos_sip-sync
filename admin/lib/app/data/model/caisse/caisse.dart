import 'package:json_annotation/json_annotation.dart';
part 'caisse.g.dart';

@JsonSerializable()
class Caisse {
  String id;
  String day;
  Caisse({required this.id, required this.day});
  factory Caisse.fromJson(Map<String, dynamic> json) => _$CaisseFromJson(json);
  Map<String, dynamic> toJson() => _$CaisseToJson(this);
}

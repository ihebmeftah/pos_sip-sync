import 'package:json_annotation/json_annotation.dart';
part 'caisse.g.dart';

@JsonSerializable()
class Caisse {
  String id;
  String day;
  DateTime start;
  DateTime close;
  Caisse({
    required this.id,
    required this.day,
    required this.start,
    required this.close,
  });
  factory Caisse.fromJson(Map<String, dynamic> json) => _$CaisseFromJson(json);
  Map<String, dynamic> toJson() => _$CaisseToJson(this);
}

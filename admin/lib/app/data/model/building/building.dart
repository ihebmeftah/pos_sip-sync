import 'package:json_annotation/json_annotation.dart';
part 'building.g.dart';

@JsonSerializable()
class Building {
  String? id;
  String name;
  String dbName;
  String openingTime;
  String closingTime;
  String location;
  double? long;
  double? lat;
  String? logo;
  List<String>? photos;

  Building({
    this.id,
    required this.name,
    required this.dbName,
    required this.openingTime,
    required this.closingTime,
    required this.location,
    this.long,
    this.lat,
    this.logo,
    this.photos,
  });
  factory Building.fromJson(Map<String, dynamic> json) =>
      _$BuildingFromJson(json);
  Map<String, dynamic> toJson() => _$BuildingToJson(this);

  Map<String, dynamic> addtoJson() => <String, dynamic>{
    'name': name,
    'dbName': dbName,
    'openingTime': openingTime,
    'closingTime': closingTime,
    'location': location,
    if (long != null) 'long': long,
    if (lat != null) 'lat': lat,
  };
}

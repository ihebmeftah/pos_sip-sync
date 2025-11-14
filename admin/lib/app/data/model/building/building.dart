import 'package:json_annotation/json_annotation.dart';
part 'building.g.dart';

@JsonSerializable()
class Building {
  String? id;
  String name;
  String dbName;
  DateTime openingTime;
  DateTime closingTime;
  String location;
  double? long;
  double? lat;
  String? logo;
  List<String>? photos;
  bool tableMultiOrder;

  Building({
    this.id,
    required this.name,
    required this.dbName,
    required this.openingTime,
    required this.closingTime,
    required this.location,
    required this.tableMultiOrder,
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
    'openingTime': openingTime.toUtc().toIso8601String(),
    'closingTime': closingTime.toUtc().toIso8601String(),
    'location': location,
    if (long != null) 'long': long,
    if (lat != null) 'lat': lat,
  };

  String get openAt {
    return "${openingTime.toLocal().hour.toString().padLeft(2, '0')}:${openingTime.toLocal().minute.toString().padLeft(2, '0')}";
  }

  String get closeAt {
    return "${closingTime.toLocal().hour.toString().padLeft(2, '0')}:${closingTime.toLocal().minute.toString().padLeft(2, '0')}";
  }
}

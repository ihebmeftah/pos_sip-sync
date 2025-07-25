// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'building.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Building _$BuildingFromJson(Map<String, dynamic> json) => Building(
  id: json['id'] as String?,
  name: json['name'] as String,
  dbName: json['dbName'] as String,
  openingTime: json['openingTime'] as String,
  closingTime: json['closingTime'] as String,
  location: json['location'] as String,
  long: (json['long'] as num?)?.toDouble(),
  lat: (json['lat'] as num?)?.toDouble(),
  logo: json['logo'] as String?,
  photos: (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$BuildingToJson(Building instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'dbName': instance.dbName,
  'openingTime': instance.openingTime,
  'closingTime': instance.closingTime,
  'location': instance.location,
  'long': instance.long,
  'lat': instance.lat,
  'logo': instance.logo,
  'photos': instance.photos,
};

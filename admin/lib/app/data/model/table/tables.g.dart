// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tables.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Table _$TableFromJson(Map<String, dynamic> json) => Table(
  id: json['id'] as String,
  name: json['name'] as String,
  seatsMax: (json['seatsMax'] as num).toInt(),
  status: $enumDecode(_$TableStatusEnumMap, json['status']),
);

Map<String, dynamic> _$TableToJson(Table instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'seatsMax': instance.seatsMax,
  'status': _$TableStatusEnumMap[instance.status]!,
};

const _$TableStatusEnumMap = {
  TableStatus.available: 'available',
  TableStatus.occupied: 'occupied',
};

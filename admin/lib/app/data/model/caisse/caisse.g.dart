// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caisse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Caisse _$CaisseFromJson(Map<String, dynamic> json) => Caisse(
  id: json['id'] as String,
  day: json['day'] as String,
  start: DateTime.parse(json['start'] as String),
  close: DateTime.parse(json['close'] as String),
);

Map<String, dynamic> _$CaisseToJson(Caisse instance) => <String, dynamic>{
  'id': instance.id,
  'day': instance.day,
  'start': instance.start.toIso8601String(),
  'close': instance.close.toIso8601String(),
};

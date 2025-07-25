// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employer _$EmployerFromJson(Map<String, dynamic> json) => Employer(
  id: json['id'] as String,
  buildingEmail: json['buildingEmail'] as String,
  building: json['building'] == null
      ? null
      : Building.fromJson(json['building'] as Map<String, dynamic>),
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EmployerToJson(Employer instance) => <String, dynamic>{
  'id': instance.id,
  'buildingEmail': instance.buildingEmail,
  'building': instance.building,
  'user': instance.user,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employer _$EmployerFromJson(Map<String, dynamic> json) =>
    Employer(
        building: json['building'] == null
            ? null
            : Building.fromJson(json['building'] as Map<String, dynamic>),
        id: json['id'] as String?,
        firstname: json['firstname'] as String,
        lastname: json['lastname'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        photo: json['photo'] as String?,
        type: $enumDecode(_$UserTypeEnumMap, json['type']),
      )
      ..password = json['password'] as String?
      ..username = json['username'] as String?
      ..employerId = json['employerId'] as String?;

Map<String, dynamic> _$EmployerToJson(Employer instance) => <String, dynamic>{
  'id': instance.id,
  'firstname': instance.firstname,
  'lastname': instance.lastname,
  'email': instance.email,
  'password': instance.password,
  'phone': instance.phone,
  'photo': instance.photo,
  'type': _$UserTypeEnumMap[instance.type]!,
  'username': instance.username,
  'employerId': instance.employerId,
  'building': instance.building,
};

const _$UserTypeEnumMap = {
  UserType.admin: 'admin',
  UserType.employer: 'employer',
};

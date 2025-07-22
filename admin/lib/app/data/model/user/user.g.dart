// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  firstname: json['firstname'] as String,
  lastname: json['lastname'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  photo: json['photo'] as String?,
  type: (json['type'] as List<dynamic>)
      .map((e) => $enumDecode(_$UserTypeEnumMap, e))
      .toList(),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'firstname': instance.firstname,
  'lastname': instance.lastname,
  'email': instance.email,
  'phone': instance.phone,
  'photo': instance.photo,
  'type': instance.type.map((e) => _$UserTypeEnumMap[e]!).toList(),
};

const _$UserTypeEnumMap = {
  UserType.admin: 'admin',
  UserType.employer: 'employer',
};

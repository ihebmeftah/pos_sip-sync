// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginUser _$LoginUserFromJson(Map<String, dynamic> json) =>
    LoginUser(
        token: json['token'] as String,
        firstname: json['firstname'] as String,
        lastname: json['lastname'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        photo: json['photo'] as String?,
        type: (json['type'] as List<dynamic>)
            .map((e) => $enumDecode(_$UserTypeEnumMap, e))
            .toList(),
      )
      ..id = json['id'] as String?
      ..password = json['password'] as String?;

Map<String, dynamic> _$LoginUserToJson(LoginUser instance) => <String, dynamic>{
  'id': instance.id,
  'firstname': instance.firstname,
  'lastname': instance.lastname,
  'email': instance.email,
  'password': instance.password,
  'phone': instance.phone,
  'photo': instance.photo,
  'type': instance.type.map((e) => _$UserTypeEnumMap[e]!).toList(),
  'token': instance.token,
};

const _$UserTypeEnumMap = {
  UserType.admin: 'admin',
  UserType.employer: 'employer',
};

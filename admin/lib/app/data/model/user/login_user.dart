import 'package:admin/app/data/model/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

import '../enums/user_role.dart';
part 'login_user.g.dart';

@JsonSerializable()
class LoginUser extends User {
  String token;
  String? username;
  String? employerId;

  LoginUser({
    required this.token,
    this.username,
    this.employerId,
    required super.firstname,
    required super.lastname,
    required super.email,
    required super.phone,
    required super.photo,
    required super.type,
    super.id,
    super.password,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) =>
      _$LoginUserFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$LoginUserToJson(this);
}

import 'package:admin/app/data/model/employer/employer.dart';
import 'package:json_annotation/json_annotation.dart';

import '../building/building.dart';
import '../enums/user_role.dart';
part 'login_user.g.dart';

@JsonSerializable()
class LoginUser extends Employer {
  String token;

  LoginUser({
    required this.token,
    required super.firstname,
    required super.lastname,
    required super.email,
    required super.phone,
    required super.photo,
    required super.type,
    required super.building
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) =>
      _$LoginUserFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$LoginUserToJson(this);
}

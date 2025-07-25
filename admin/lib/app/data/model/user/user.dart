import 'package:admin/app/data/model/enums/user_role.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  String? id;
  String firstname;
  String lastname;
  String email;
  String? password;
  String phone;
  String? photo;
  List<UserType> type;

  User({
    this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    this.photo,
    this.password,
    required this.type,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

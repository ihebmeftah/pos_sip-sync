import 'package:admin/app/data/model/building/building.dart';
import 'package:json_annotation/json_annotation.dart';

import '../enums/user_role.dart';
import '../user/user.dart';

part 'employer.g.dart';

@JsonSerializable()
class Employer extends User {
  Building? building;
  Employer({
    this.building,
    String? id,
    required super.firstname,
    required super.lastname,
    required super.email,
    required super.phone,
    required super.photo,
    required super.type,
  });

  factory Employer.fromJson(Map<String, dynamic> json) =>
      _$EmployerFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EmployerToJson(this);
}

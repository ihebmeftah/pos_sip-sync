import 'package:admin/app/data/model/building/building.dart';
import 'package:admin/app/data/model/user/user.dart';
import 'package:json_annotation/json_annotation.dart';
part 'employer.g.dart';

@JsonSerializable()
class Employer {
  String id;
  String buildingEmail;
  Building? building;
  User user;

  Employer({
    required this.id,
    required this.buildingEmail,
    this.building,
    required this.user,
  });

  factory Employer.fromJson(Map<String, dynamic> json) =>
      _$EmployerFromJson(json);

  Map<String, dynamic> toJson() => _$EmployerToJson(this);
}

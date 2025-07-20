import 'package:admin/app/data/model/enums/table_status.dart';
import 'package:json_annotation/json_annotation.dart';
part 'tables.g.dart';

@JsonSerializable()
class Table {
  String id;
  String name;
  int seatsMax;
  TableStatus status;
  @JsonKey(includeFromJson: false, includeToJson: false)
  int numTable;
  Table({
    required this.id,
    required this.name,
    required this.seatsMax,
    required this.status,
    this.numTable = 0,
  }) {
    numTable = int.tryParse(name.split(".").first.split("-").last)!;
  }

  factory Table.fromJson(Map<String, dynamic> json) => _$TableFromJson(json);
  Map<String, dynamic> toJson() => _$TableToJson(this);
}

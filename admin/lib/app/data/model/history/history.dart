import 'package:json_annotation/json_annotation.dart';
part 'history.g.dart';

@JsonSerializable()
class History {
  final String id;
  final String message;

  History({required this.id, required this.message});

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}

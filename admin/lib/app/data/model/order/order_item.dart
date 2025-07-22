import 'package:admin/app/data/model/article/article.dart';
import 'package:admin/app/data/model/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_item.g.dart';

@JsonSerializable()
class OrderItem {
  String? id;
  Article article;
  bool payed;
  User passedBy;

  OrderItem({required this.id, required this.article, this.payed = false, required this.passedBy});

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

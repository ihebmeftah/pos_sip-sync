import 'package:json_annotation/json_annotation.dart';

import '../table/tables.dart';
import 'order_item.dart';
part 'order.g.dart';

enum OrderStatus { progress, delivred, payed }

@JsonSerializable()
class Order {
  String? id;
  OrderStatus status;
  List<OrderItem> items;
  @JsonKey(name: 'table')
  Table table;

  Order({
    this.id,
    this.status = OrderStatus.progress,
    this.items = const [],
    required this.table,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

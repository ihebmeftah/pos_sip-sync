// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  id: json['id'] as String?,
  status:
      $enumDecodeNullable(_$OrderStatusEnumMap, json['status']) ??
      OrderStatus.progress,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  table: Table.fromJson(json['table'] as Map<String, dynamic>),
  passedBy: User.fromJson(json['passedBy'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'id': instance.id,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'items': instance.items,
  'table': instance.table,
  'passedBy': instance.passedBy,
};

const _$OrderStatusEnumMap = {
  OrderStatus.progress: 'progress',
  OrderStatus.delivred: 'delivred',
  OrderStatus.payed: 'payed',
};

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
  openedBy: User.fromJson(json['openedBy'] as Map<String, dynamic>),
  closedBy: json['closedBy'] == null
      ? null
      : User.fromJson(json['closedBy'] as Map<String, dynamic>),
)..ref = json['ref'] as String?;

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'id': instance.id,
  'ref': instance.ref,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'items': instance.items,
  'table': instance.table,
  'openedBy': instance.openedBy,
  'closedBy': instance.closedBy,
};

const _$OrderStatusEnumMap = {
  OrderStatus.progress: 'progress',
  OrderStatus.delivred: 'delivred',
  OrderStatus.payed: 'payed',
};

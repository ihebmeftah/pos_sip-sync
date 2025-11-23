// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
  id: json['id'] as String?,
  article: Article.fromJson(json['article'] as Map<String, dynamic>),
  payed: json['payed'] as bool? ?? false,
  addedBy: User.fromJson(json['addedBy'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
  'id': instance.id,
  'article': instance.article,
  'payed': instance.payed,
  'addedBy': instance.addedBy,
};

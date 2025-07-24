import 'package:admin/app/data/apis/htthp_helper.dart';
import 'package:admin/app/data/model/order/order.dart';
import 'package:admin/app/data/model/order/order_item.dart';

class OrderApi {
  Future<List<Order>> getOrders([OrderStatus? orderStatus]) {
    return HttpHelper.get<List<Order>>(
      endpoint: '/order',
      queryParams: orderStatus != null ? {'status': orderStatus.name} : null,
      fromJson: (json) => (json as List)
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<Order> getOrderById(String id) async {
    return await HttpHelper.get<Order>(
      endpoint: '/order/$id',
      fromJson: (json) => Order.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Order> passOrder({
    required String tableId,
    required List<String> articlesIds,
  }) async {
    return await HttpHelper.post<Order>(
      endpoint: '/order',
      body: {"tableId": tableId, "articlesIds": articlesIds},
      fromJson: (json) => Order.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<OrderItem> payOrderItem({required String itemId}) async {
    return await HttpHelper.patch<OrderItem>(
      endpoint: '/order/item/$itemId',
      fromJson: (json) => OrderItem.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Order> payOrderAllItems({required String orderId}) async {
    return await HttpHelper.patch<Order>(
      endpoint: '/order/$orderId/pay-items',
      fromJson: (json) => Order.fromJson(json as Map<String, dynamic>),
    );
  }
}

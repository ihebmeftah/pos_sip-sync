import 'package:admin/app/data/apis/order_api.dart';
import 'package:get/get.dart';

import '../../../data/model/order/order.dart';

class OrderController extends GetxController with StateMixin {
  final RxList<Order> orders = <Order>[].obs;
  @override
  void onInit() async {
    await getOrders();
    super.onInit();
  }

  Future<void> getOrders() async {
    try {
      final orderStatus = currentTabIndex == 0
          ? null
          : currentTabIndex == 1
          ? OrderStatus.progress
          : OrderStatus.payed;
      orders(await OrderApi().getOrders(orderStatus));
      change(orders, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error('Failed to load orders'));
    }
  }

  int currentTabIndex = 1;
  changeTab(int index) {
    currentTabIndex = index;
    getOrders();
  }
}

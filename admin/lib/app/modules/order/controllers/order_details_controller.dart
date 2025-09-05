import 'package:admin/app/data/apis/history_api.dart';
import 'package:admin/app/data/local/local_storage.dart';
import 'package:admin/app/data/model/history/history.dart';
import 'package:admin/app/data/model/order/order.dart';
import 'package:admin/app/data/model/order/order_item.dart';
import 'package:admin/app/modules/order/controllers/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/apis/order_api.dart';
import '../../../data/model/enums/table_status.dart';
import '../../tables/controllers/tables_controller.dart';

class OrderDetailsController extends GetxController with StateMixin {
  String get id => Get.parameters['id']!;
  Order? order;
  final orderHistory = <History>[].obs;

  @override
  void onInit() {
    getOrderById();
    super.onInit();
  }

  num get totalPrice =>
      order!.items.fold<num>(0.0, (sum, item) => sum + item.article.price);
  num get paidAmount => order!.items
      .where((item) => item.payed)
      .fold<num>(0.0, (sum, item) => sum + item.article.price);
  num get unpaidAmount => (totalPrice - paidAmount);

  Future<void> getOrderById() async {
    try {
      order = await OrderApi().getOrderById(id);
      getOrderHistory();
      if (order == null) {
        change(null, status: RxStatus.empty());
      } else {
        change(order, status: RxStatus.success());
      }
    } catch (e) {
      change(null, status: RxStatus.error('Failed to load order'));
    }
  }

  Future<void> getOrderHistory() async {
    try {
      orderHistory.value = await HistoryApi().getOrderHistory(id);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load order history',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> payForItem(OrderItem item) async {
    try {
      final updatedItem = await OrderApi().payOrderItem(itemId: item.id!);
      order!.items.firstWhere((i) => i.id == updatedItem.id).payed = true;
      update([item.id!, "pay"]);
      if (order!.items.every((item) => item.payed)) {
        order!.status = OrderStatus.payed;
        order!.table.status = TableStatus.available;
        order!.closedBy = LocalStorage().user;
        Get.find<TablesController>().updateTable(order!.table);
        // update(['table-status', 'order-status']);
        change(order, status: RxStatus.success());
      }
      Get.find<OrderController>().getOrders();
      Get.snackbar(
        'Payment Processed',
        'Payment for ${item.article.name} has been processed',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      getOrderHistory();
    } catch (e) {
      Get.snackbar(
        'Payment Error',
        'Failed to pay for item: ${item.article.name}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> payAllItems() async {
    try {
      order = await OrderApi().payOrderAllItems(orderId: order!.id!);
      Get.find<OrderController>().getOrders();
      Get.find<TablesController>().updateTable(order!.table);
      Get.snackbar(
        'Payment Processed',
        'All items have been paid',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      getOrderHistory();
      change(order, status: RxStatus.success());
    } catch (e) {
      Get.snackbar(
        'Payment Error',
        'Failed to pay for all items in the order',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void addNewItem() {
    Get.snackbar(
      'Add Item',
      'Feature to add new items will be implemented',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void closeOrder() {
    final hasUnpaidItems = order!.items.any((item) => !item.payed);
    Get.dialog(
      AlertDialog(
        title: Text(hasUnpaidItems ? 'Close Order' : 'Complete Order'),
        content: Text(
          hasUnpaidItems
              ? 'This order has unpaid items. Are you sure you want to close it?'
              : 'Mark this order as completed?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.back(); // Return to orders list
              Get.snackbar(
                'Order Updated',
                hasUnpaidItems
                    ? 'Order has been closed'
                    : 'Order has been completed',
                backgroundColor: Colors.blue,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: hasUnpaidItems ? Colors.orange : Colors.blue,
            ),
            child: Text(hasUnpaidItems ? 'Close' : 'Complete'),
          ),
        ],
      ),
    );
  }
}

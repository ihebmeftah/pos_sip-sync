import 'package:admin/app/data/model/order/order.dart';
import 'package:admin/app/data/model/order/order_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/apis/order_api.dart';

class OrderDetailsController extends GetxController with StateMixin {
  String get id => Get.parameters['id']!;
  Order? order;
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
  num get unpaidAmount => totalPrice - paidAmount;

  Future<void> getOrderById() async {
    try {
      order = await OrderApi().getOrderById(id);
      if (order == null) {
        change(null, status: RxStatus.empty());
      } else {
        change(order, status: RxStatus.success());
      }
    } catch (e) {
      change(null, status: RxStatus.error('Failed to load order'));
    }
  }

  Future<void> payForItem(OrderItem item) async {
    try {
      final updatedOrder = await OrderApi().payOrderItem(itemId: item.id!);
      order!.items.firstWhere((i) => i.id == item.id).payed = true;
      update([item.id!, "pay"]);
      if (updatedOrder.status != order!.status) {
        order!.status = updatedOrder.status;
        update(['order-status']);
      }
      if (updatedOrder.table.status != order!.table.status) {
        order!.table.status = updatedOrder.table.status;
        update(['table-status']);
      }
      Get.back();
      Get.snackbar(
        'Payment Processed',
        'Payment for ${item.article.name} has been processed',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
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
      Get.back();
      Get.snackbar(
        'Payment Processed',
        'All items have been paid',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
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

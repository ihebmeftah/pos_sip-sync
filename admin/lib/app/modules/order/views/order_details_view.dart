import 'package:admin/app/common/appemptyscreen.dart';
import 'package:admin/app/modules/order/widgets/order_amount_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/order_details_controller.dart';

class OrderDetailsView extends GetView<OrderDetailsController> {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 5,
          children: [
            Icon(
              Icons.receipt_long,
              color: Theme.of(context).colorScheme.primary,
            ),
            const Text(
              'Order Details',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.getOrderById(),
          ),
        ],
      ),
      body: controller.obx(
        (state) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 20,
            children: [
              /// Table Information
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Icon(
                    Icons.table_bar,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                  Column(
                    children: [
                      Text(
                        'Table: ${controller.order!.table.numTable}',
                        style: context.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GetBuilder<OrderDetailsController>(
                        id: 'table-status',
                        builder: (_) {
                          return Text(
                            'Table status: ${controller.order!.table.status.name}',
                            style: context.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      GetBuilder<OrderDetailsController>(
                        id: 'order-status',
                        builder: (_) {
                          return Text(
                            'Order status: ${controller.order!.status.name}',
                            style: context.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),

              /// Order items details
              Row(
                spacing: 5,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  Text(
                    'Order Items (${controller.order!.items.length})',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              /// Order items list
              Expanded(
                child: ListView.builder(
                  itemCount: controller.order!.items.length,
                  itemBuilder: (context, index) {
                    return GetBuilder<OrderDetailsController>(
                      id: controller.order!.items[index].id,
                      builder: (_) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              spacing: 10,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.fastfood,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    size: 28,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller
                                            .order!
                                            .items[index]
                                            .article
                                            .name,
                                        style: context.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      Text(
                                        '${controller.order!.items[index].article.price.toStringAsFixed(2)} DT',
                                        style: context.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            controller.order!.items[index].payed
                                            ? Colors.green[50]
                                            : Colors.orange[50],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        spacing: 5,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            controller.order!.items[index].payed
                                                ? Icons.check_circle
                                                : Icons.schedule,
                                            size: 16,
                                            color:
                                                controller
                                                    .order!
                                                    .items[index]
                                                    .payed
                                                ? Colors.green
                                                : Colors.orange,
                                          ),
                                          Text(
                                            controller.order!.items[index].payed
                                                ? 'PAID'
                                                : 'UNPAID',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  controller
                                                      .order!
                                                      .items[index]
                                                      .payed
                                                  ? Colors.green[700]
                                                  : Colors.orange[700],
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (!controller.order!.items[index].payed)
                                      ElevatedButton(
                                        onPressed: () => Get.dialog(
                                          AlertDialog(
                                            title: const Text(
                                              'Confirm Payment',
                                            ),
                                            content: Text(
                                              'Pay for ${controller.order!.items[index].article.name}?\nAmount: ${controller.order!.items[index].article.price.toStringAsFixed(2)} DT',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Get.back(),
                                                child: const Text('Cancel'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                   controller.payForItem(
                                                    controller
                                                        .order!
                                                        .items[index],
                                                  ),
                                                child: const Text('Pay'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.zero,
                                          fixedSize: const Size(80, 30),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Pay',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              ///  Total Amount, Paid Amount & Remaining Amount
              GetBuilder<OrderDetailsController>(
                id: "pay",
                builder: (_) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.brown[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      spacing: 5,
                      children: [
                        OrderAmountWidget(
                          label: 'Total Amount',
                          amount: controller.totalPrice,
                          color: Colors.black87,
                        ),
                        OrderAmountWidget(
                          label: 'Paid Amount',
                          amount: controller.paidAmount,
                          color: Colors.green,
                        ),
                        OrderAmountWidget(
                          label: 'Remaining',
                          amount: controller.unpaidAmount,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  );
                },
              ),

              /// Action Buttons
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Get.dialog(
                        AlertDialog(
                          title: const Text('Pay All Items'),
                          content: Text(
                            'Pay for all unpaid items?\nTotal Amount: ${controller.totalPrice.toStringAsFixed(2)} DT',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: controller.payAllItems,
                              child: const Text('Pay All'),
                            ),
                          ],
                        ),
                      ),
                      icon: const Icon(Icons.payment),
                      label: const Text('Pay All'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.closeOrder,
                      icon: const Icon(Icons.check_circle),
                      label: Text('Close Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onEmpty: const Appemptyscreen(),
      ),
    );
  }
}

import 'package:admin/app/common/appemptyscreen.dart';
import 'package:admin/app/modules/order/widgets/order_amount_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/order_details_controller.dart';
import '../widgets/table_info_widget.dart';

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
            spacing: 10,
            children: [
              TableInfoWidget(table: controller.order!.table),

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
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  fixedSize: Size(Get.width, 50),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.brown),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                label: Text("Add Item"),
                icon: Icon(Icons.add),
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
                                        "Passed by: ${'${controller.order!.items[index].passedBy.firstname} ${controller.order!.items[index].passedBy.lastname}'}",
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
                                        onPressed: () => controller.payForItem(
                                          controller.order!.items[index],
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

              OrderBottomWidget(
                order: controller.order!,
                history: controller.orderHistory,
              ),
            ],
          ),
        ),
        onEmpty: const Appemptyscreen(),
      ),
    );
  }
}

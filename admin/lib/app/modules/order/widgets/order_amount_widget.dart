import 'package:admin/app/data/model/history/history.dart';
import 'package:admin/app/data/model/order/order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/order_details_controller.dart';

class OrderBottomWidget extends StatelessWidget {
  const OrderBottomWidget({
    super.key,
    required this.order,
    required this.history,
  });
  final Order order;
  final List<History> history;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///  Total Amount, Paid Amount & Remaining Amount
        GetBuilder<OrderDetailsController>(
          id: "pay",
          builder: (ctr) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.brown[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                spacing: 5,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Paid Amount',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        '${ctr.paidAmount.toStringAsFixed(2)} DT',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text('|', style: TextStyle(color: Colors.black)),
                      Text(
                        'Remaining',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        '${ctr.unpaidAmount.toStringAsFixed(2)} DT',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 10),

        /// Action Buttons
        if (order.status != OrderStatus.payed)
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: Get.find<OrderDetailsController>().payAllItems,
                  icon: const Icon(Icons.payment),
                  label: GetBuilder<OrderDetailsController>(
                    id: "pay",
                    builder: (_) {
                      return Text(
                        'Pay \n(${Get.find<OrderDetailsController>().unpaidAmount.toStringAsFixed(2)} DT)',
                      );
                    },
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: Get.find<OrderDetailsController>().closeOrder,
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
        TextButton(
          onPressed: () => Get.bottomSheet(
            SizedBox(
              height: Get.height * 0.7,
              width: Get.width,
              child: Padding(
                padding: EdgeInsetsGeometry.all(20),
                child: Column(
                  children: [
                    if (order.status == OrderStatus.payed)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order started by: ${order.openedBy.firstname} ${order.openedBy.lastname}",
                            style: context.textTheme.titleMedium!.copyWith(
                              backgroundColor: Colors.blue.shade500,
                            ),
                          ),
                          Text(
                            "Closed by : ${order.closedBy?.firstname} ${order.closedBy?.lastname}",
                            style: context.textTheme.titleMedium!.copyWith(
                              backgroundColor: Colors.red.shade500,
                            ),
                          ),
                        ],
                      ),
                    Expanded(
                      child: history.isEmpty
                          ? Center(
                              child: Text(
                                'No history available for this order',
                                style: context.textTheme.titleMedium,
                              ),
                            )
                          : ListView.builder(
                              itemBuilder: (context, index) => ListTile(
                                title: Text("${history.length - index}"),
                                subtitle: Text(history[index].message),
                              ),
                              itemCount: history.length,
                              shrinkWrap: true,
                            ),
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.white,
          ),
          child: const Text('Order History'),
        ),
      ],
    );
  }
}

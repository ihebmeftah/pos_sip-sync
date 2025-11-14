import 'package:admin/app/data/local/local_storage.dart';
import 'package:admin/app/data/model/enums/user_role.dart';
import 'package:admin/app/modules/index/controllers/index_controller.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/order_controller.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: controller.currentTabIndex,
      child: Scaffold(
        appBar:
            (Get.find<IndexController>().currBnb != 3 &&
                    LocalStorage().user!.type == UserType.admin) ||
                (Get.find<IndexController>().currBnb != 1 &&
                    LocalStorage().user!.type == UserType.employer)
            ? null
            : AppBar(title: const Text('Orders'), centerTitle: true),
        body: controller.obx(
          (state) => RefreshIndicator(
            onRefresh: controller.getOrders,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                spacing: 10,
                children: [
                  TabBar(
                    onTap: controller.changeTab,
                    labelStyle: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    dividerHeight: 0,
                    indicator: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(text: 'All'),
                      Tab(text: 'Progress'),
                      Tab(text: 'Paid'),
                    ],
                  ),
                  Expanded(
                    child: controller.orders.isEmpty
                        ? const Center(child: Text('No orders found'))
                        : ListView.separated(
                            itemCount: controller.orders.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 15),
                            itemBuilder: (context, index) {
                              final order = controller.orders[index];
                              final totalPrice = order.items.fold<double>(
                                0.0,
                                (sum, item) => sum + item.article.price,
                              );
                              return ListTile(
                               
                                tileColor: _getStatusColor(
                                  order.status.name,
                                ).withValues(alpha: 0.1),
                                onTap: () => Get.toNamed(
                                  '${Routes.ORDER_DETAILS}/${order.id}',
                                ),
                                leading: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      order.status.name,
                                    ).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    order.table.name.split(" ").last,
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(color: Colors.grey[600]),
                                  ),
                                ),

                                title: Row(
                                  children: [
                                    Text(
                                      '#${controller.orders[index].ref}',
                                      style: context.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Spacer(),
                                    Row(
                                      spacing: 5,
                                      children: [
                                        Icon(Icons.shopping_cart, size: 16),
                                        Text(
                                          '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                subtitle: Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(order.status.name),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "${order.status.name.toUpperCase()} - ${totalPrice.toStringAsFixed(2)} DT",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'progress':
        return Colors.orange;
      case 'delivred':
        return Colors.green;
      case 'payed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

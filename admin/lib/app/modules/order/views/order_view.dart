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
                        : ListView.builder(
                            itemCount: controller.orders.length,
                            itemBuilder: (context, index) {
                              final order = controller.orders[index];
                              final totalPrice = order.items.fold<double>(
                                0.0,
                                (sum, item) => sum + item.article.price,
                              );
                              return Card(
                                child: ExpansionTile(
                                  tilePadding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 5,
                                  ),
                                  childrenPadding: const EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                  ),
                                  leading: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                        order.status.name,
                                      ).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.receipt_long,
                                      color: _getStatusColor(order.status.name),
                                      size: 24,
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Order #${controller.orders[index].ref}',
                                          style: context.textTheme.titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                            order.status.name,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          order.status.name.toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Column(
                                      spacing: 5,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.table_restaurant,
                                              color: Colors.grey[600],
                                            ),
                                            Text(
                                              order.table.name,
                                              style: context
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: Colors.grey[600],
                                                  ),
                                            ),
                                            const Spacer(),
                                            Icon(
                                              Icons.shopping_cart,
                                              size: 16,
                                              color: Colors.grey[600],
                                            ),
                                            Text(
                                              '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                                              style: context
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: Colors.grey[600],
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primaryContainer,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.attach_money,
                                                size: 18,
                                                color: Colors.green.shade900,
                                              ),
                                              Text(
                                                '${totalPrice.toStringAsFixed(2)} DT',
                                                style: context
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  children: [
                                    GestureDetector(
                                      onTap: () => Get.toNamed(
                                        '${Routes.ORDER_DETAILS}/${order.id}',
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: order.items.map((item) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                              left: 16,
                                              right: 16,
                                              bottom: 8,
                                            ),
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.grey[200]!,
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              spacing: 10,
                                              children: [
                                                Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Icon(
                                                    Icons.fastfood,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item
                                                                .article
                                                                .name
                                                                .capitalizeFirst ??
                                                            '',
                                                        style: context
                                                            .textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                      if (item
                                                                  .article
                                                                  .description !=
                                                              null &&
                                                          item
                                                              .article
                                                              .description!
                                                              .isNotEmpty) ...[
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          item
                                                              .article
                                                              .description!,
                                                          style: context
                                                              .textTheme
                                                              .bodySmall
                                                              ?.copyWith(
                                                                color: Colors
                                                                    .grey[500],
                                                              ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            item.payed
                                                                ? Icons
                                                                      .check_circle
                                                                : Icons
                                                                      .schedule,
                                                            size: 16,
                                                            color: item.payed
                                                                ? Colors.green
                                                                : Colors.orange,
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            item.payed
                                                                ? 'Paid'
                                                                : 'Pending Payment',
                                                            style: context
                                                                .textTheme
                                                                .bodySmall
                                                                ?.copyWith(
                                                                  color:
                                                                      item.payed
                                                                      ? Colors
                                                                            .green
                                                                      : Colors
                                                                            .orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  '${item.article.price.toStringAsFixed(2)} DT',
                                                  style: context
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(
                                                          context,
                                                        ).colorScheme.primary,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () => Get.toNamed(
                                        '${Routes.ORDER_DETAILS}/${order.id}',
                                      ),
                                      icon: const Icon(Icons.info_outline),
                                      label: const Text('View Details'),
                                    ),
                                  ],
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

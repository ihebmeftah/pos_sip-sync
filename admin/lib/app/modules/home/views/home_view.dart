import 'package:admin/app/modules/home/widgets/empty_stats_widget.dart';
import 'package:admin/app/modules/home/widgets/stats_card_widget.dart';
import 'package:admin/app/modules/home/widgets/top_item_widget.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:admin/themes/apptheme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.obx(
        (_) => RefreshIndicator(
          onRefresh: controller.getStats,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Header
                Text(
                  'Welcome back, ${controller.loggedUser.firstname}!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                // Revenue and Order Statistics Cards
                Row(
                  children: [
                    Expanded(
                      child: StatsCardWidget(
                        title: 'Total Revenue',
                        value:
                            '${controller.totalRevenue.toStringAsFixed(2)} DT',
                        icon: FluentIcons.money_24_filled,
                        color: AppTheme().primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatsCardWidget(
                        title: 'Avg Order Value',
                        value:
                            '${controller.avgOrderValue.toStringAsFixed(2)} DT',
                        icon: FluentIcons.receipt_money_24_filled,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: StatsCardWidget(
                        title: 'Total Orders',
                        value: '${controller.totalOrders}',
                        icon: FluentIcons.receipt_24_filled,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatsCardWidget(
                        title: 'Paid Orders',
                        value: '${controller.paidOrders}',
                        icon: FluentIcons.checkmark_circle_24_filled,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Order Status Chart
                _buildChartSection(
                  context,
                  title: 'Order Status Distribution',
                  child: _buildOrderStatusChart(context),
                ),
                const SizedBox(height: 24),

                // Items Sold Chart
                _buildChartSection(
                  context,
                  title: 'Business Overview',
                  child: _buildBusinessOverviewChart(context),
                ),
                const SizedBox(height: 24),

                // Top Articles Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Articles',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(Routes.ARTICLE),
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                controller.topArticles.isEmpty
                    ? EmptyStatsWidget(
                        message: 'No articles data yet',
                        icon: FluentIcons.food_24_regular,
                      )
                    : Column(
                        children: controller.topArticles.map((entry) {
                          return TopItemWidget(
                            title: entry.key.name,
                            subtitle:
                                entry.key.categorie?.name ?? 'No category',
                            count: entry.value,
                            price: entry.key.price,
                            icon: FluentIcons.food_24_regular,
                          );
                        }).toList(),
                      ),

                const SizedBox(height: 24),

                // Top Categories Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Categories',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(Routes.CATEGORIE),
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                controller.topCategories.isEmpty
                    ? EmptyStatsWidget(
                        message: 'No categories data yet',
                        icon: FluentIcons.grid_24_regular,
                      )
                    : Column(
                        children: controller.topCategories.map((entry) {
                          return TopItemWidget(
                            title: entry.key.name,
                            subtitle: '${entry.value} orders',
                            count: entry.value,
                            icon: FluentIcons.grid_24_regular,
                          );
                        }).toList(),
                      ),
              ],
            ),
          ),
        ),
        onLoading: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildChartSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildOrderStatusChart(BuildContext context) {
    final total = controller.totalOrders;
    final paid = controller.paidOrders;
    final unpaid = total - paid;

    if (total == 0) {
      return EmptyStatsWidget(
        message: 'No order data available',
        icon: FluentIcons.chart_multiple_24_regular,
      );
    }

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 60,
          sections: [
            PieChartSectionData(
              color: Colors.green,
              value: paid.toDouble(),
              title: '${((paid / total) * 100).toStringAsFixed(1)}%',
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              color: Colors.orange,
              value: unpaid.toDouble(),
              title: '${((unpaid / total) * 100).toStringAsFixed(1)}%',
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessOverviewChart(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBarIndicator(
              context,
              label: 'Articles',
              value: controller.totalArticles,
              color: Colors.blue,
            ),
            _buildBarIndicator(
              context,
              label: 'Categories',
              value: controller.totalCategories,
              color: Colors.purple,
            ),
            _buildBarIndicator(
              context,
              label: 'Items Sold',
              value: controller.totalItemsSold,
              color: Colors.teal,
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _getMaxValue().toDouble(),
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 0:
                          return const Text('Articles');
                        case 1:
                          return const Text('Categories');
                        case 2:
                          return const Text('Items Sold');
                        default:
                          return const Text('');
                      }
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(show: true, drawVerticalLine: false),
              borderData: FlBorderData(show: false),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: controller.totalArticles.toDouble(),
                      color: Colors.blue,
                      width: 20,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6),
                      ),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: controller.totalCategories.toDouble(),
                      color: Colors.purple,
                      width: 20,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6),
                      ),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(
                      toY: controller.totalItemsSold.toDouble(),
                      color: Colors.teal,
                      width: 20,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  int _getMaxValue() {
    final values = [
      controller.totalArticles,
      controller.totalCategories,
      controller.totalItemsSold,
    ];
    final max = values.reduce((a, b) => a > b ? a : b);
    return (max * 1.2).ceil(); // Add 20% padding
  }

  Widget _buildBarIndicator(
    BuildContext context, {
    required String label,
    required int value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        ),
        Text(
          value.toString(),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart' hide Table;
import 'package:get/get.dart';

import '../../../data/model/table/tables.dart';
import '../controllers/order_details_controller.dart';

class TableInfoWidget extends StatelessWidget {
  const TableInfoWidget({super.key, required this.table});
  final Table table;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        Icon(
          Icons.table_bar,
          color: Theme.of(context).colorScheme.primary,
          size: 40,
        ),
        Row(
          spacing: 5,
          children: [
            Text(
              table.name,
              style: context.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            GetBuilder<OrderDetailsController>(
              id: 'table-status',
              builder: (controller) {
                return Text(
                  controller.order!.table.status.name,
                  style: context.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

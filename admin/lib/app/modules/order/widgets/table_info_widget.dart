import 'package:flutter/material.dart' hide Table;
import '../../../data/model/table/tables.dart';

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
        Row(spacing: 5, children: [
           
          
          ],
        ),
      ],
    );
  }
}
